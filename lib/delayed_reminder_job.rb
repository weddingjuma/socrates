#Fedena
#Copyright 2011 Foradian Technologies Private Limited
#
#This product includes software developed at
#Project Fedena - http://www.projectfedena.org/
#
#Licensed under the Apache License, Version 2.0 (the "License");
#you may not use this file except in compliance with the License.
#You may obtain a copy of the License at
#
#  http://www.apache.org/licenses/LICENSE-2.0
#
#Unless required by applicable law or agreed to in writing, software
#distributed under the License is distributed on an "AS IS" BASIS,
#WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#See the License for the specific language governing permissions and
#limitations under the License.

class DelayedReminderJob

  def initialize(*args)
    opts = args.extract_options!
    @sender_id = opts[:sender_id]
    @recipient_ids = Array(opts[:recipient_ids]).flatten.uniq
    @subject = opts[:subject]
    @message = opts[:message]
    @body = opts[:body]
  end

  def perform
    @recipient_ids.each { |r_id| Reminder.create(sender: @sender_id, recipient: r_id, subject: @subject, body: @body) }
  end

end
