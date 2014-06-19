#
# Author:: Serdar Sutay (<serdar@opscode.com>)
# Copyright:: Copyright 2013 Opscode, Inc.
# License:: Apache License, Version 2.0
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

require 'seth/win32/api/synchronization'

class Seth
  module ReservedNames::Win32
    class Mutex
      include Seth::ReservedNames::Win32::API::Synchronization

      def initialize(name)
        @name = name
        create_system_mutex
      end

      attr_reader :handle
      attr_reader :name

      #####################################################
      # Attempts to grab the mutex.
      # Returns true if the mutex is grabbed or if it's already
      # owned; false otherwise.
      def test
        WaitForSingleObject(handle, 0) == WAIT_OBJECT_0
      end

      #####################################################
      # Attempts to grab the mutex and waits until it is acquired.
      def wait
        loop do
          wait_result = WaitForSingleObject(handle, 1000)
          case wait_result
          when WAIT_TIMEOUT
            # We are periodically waking up in order to give ruby a
            # chance to process any signal it got while we were
            # sleeping. This condition shouldn't contain any logic
            # other than sleeping.
            sleep 0.1
          when WAIT_ABANDONED
            # Previous owner of the mutex died before it can release the
            # mutex. Log a warning and continue.
            Seth::Log.debug "Existing owner of the mutex exited prematurely."
            break
          when WAIT_OBJECT_0
            # Mutex is successfully acquired.
            break
          else
            Seth::Log.error("Failed to acquire system mutex '#{name}'. Return code: #{wait_result}")
            Seth::ReservedNames::Win32::Error.raise!
          end
        end
      end

      #####################################################
      # Releaes the mutex
      def release
        # http://msdn.microsoft.com/en-us/library/windows/desktop/ms685066(v=vs.85).aspx
        # Note that release method needs to be called more than once
        # if mutex is acquired more than once.
        unless ReleaseMutex(handle)
          # Don't fail things in here if we can't release the mutex.
          # Because it will be automatically released when the owner
          # of the process goes away and this class is only being used
          # to synchronize seth-clients runs on a node.
          Seth::Log.error("Can not release mutex '#{name}'. This might cause issues \
if the mutex is attempted to be acquired by other threads.")
          Seth::ReservedNames::Win32::Error.raise!
        end
      end

      private

      def create_system_mutex
        # First check if there exists a mutex in the system with the
        # given name. We need only synchronize rights if a mutex is
        # already created.
        # InheritHandle is set to true so that subprocesses can
        # inherit the ownership of the mutex.
        @handle = OpenMutexW(SYNCHRONIZE, true, name.to_wstring)

        if @handle == 0
          # Mutext doesn't exist so create one.
          # In the initial creation of the mutex initial_owner is set to
          # false so that mutex will not be acquired until someone calls
          # acquire.
          # In order to call "*W" windows apis, strings needs to be
          # encoded as wide strings.
          @handle = CreateMutexW(nil, false, name.to_wstring)

          # Looks like we can't create the mutex for some reason.
          # Fail early.
          if @handle == 0
            Seth::Log.error("Failed to create system mutex with name'#{name}'")
            Seth::ReservedNames::Win32::Error.raise!
          end
        end
      end
    end
  end
end


