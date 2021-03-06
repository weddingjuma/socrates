# Fedena
# Copyright 2011 Foradian Technologies Private Limited
#
# This product includes software developed at
# Project Fedena - http://www.projectfedena.org/
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
class WeekdayController < ApplicationController
  before_filter :login_required
  before_filter :week_array, :only => [:index, :week, :create]
  filter_access_to :all

  def index
    @batches  = Batch.active
    @weekdays = Weekday.default
  end

  def week
    @batch = nil
    if params[:batch_id].blank?
      @weekdays = Weekday.default
    else
      @weekdays = Weekday.for_batch(params[:batch_id])
      @b        = Batch.find params[:batch_id]
    end
    render :update do |page|
      page.replace_html "weekdays", :partial => "weekdays"
    end
  end

  def create
    if request.post?
      new_weekdays   = params[:weekdays] || []
      batch_id       = params[:weekday][:batch_id].present? ? params[:weekday][:batch_id] : nil
      old            = Weekday.find(:all, :conditions => { :batch_id => batch_id, :is_deleted => false })
      old_weekdays   = old.map{ |w| w.weekday }
      flash[:notice] = ""
      (new_weekdays - old_weekdays).each do |new|
        Weekday.add_day(batch_id, new)
      end
      (old_weekdays - new_weekdays).each do |week|
        weekday = Weekday.find_by_weekday(week.to_s, :conditions => { :batch_id => batch_id })
        weekday.deactivate
      end
      flash[:notice] = "#{t('weekdays_modified')}"
    end
    redirect_to :action => "index"
  end

  private

    def week_array
      @day  = ["#{t('sunday')}", "#{t('monday')}", "#{t('tuesday')}", "#{t('wednesday')}", "#{t('thursday')}", "#{t('friday')}", "#{t('saturday')}"]
      @days = ["0", "1", "2", "3", "4", "5", "6"]
    end
end
