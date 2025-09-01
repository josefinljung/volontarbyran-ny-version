class PagesController < ApplicationController
    def home
    @task_count = Task.count
  end
end
