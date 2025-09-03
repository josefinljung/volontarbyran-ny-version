class TasksController < ApplicationController
  before_action :set_task, only: %i[ show edit update destroy ]
  before_action :authenticate_user!, except: [:index, :show]
  before_action :correct_user, only: [:edit, :update, :destroy]

  # GET /tasks
    def index
    if params[:category_id].present?
      @tasks = Task.joins(:categories).where(categories: { id: params[:category_id] })
    else
      @tasks = Task.all
    end

    @pagy, @tasks = pagy(@tasks, items: 10)
  end


  # GET /tasks/1
  def show
  end

  # GET /tasks/new
  def new
    @task = current_user.tasks.build
  end

  # GET /tasks/1/edit
  def edit
  end

  # POST /tasks
  def create
    @task = current_user.tasks.build(task_params)

    if @task.save
      redirect_to @task, notice: t("tasks.create.success")
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /tasks/1
  def update
    if @task.update(task_params)
      redirect_to @task, notice: t("tasks.update.success")
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /tasks/1
  def destroy
    @task.destroy
    redirect_to tasks_url, notice: t("tasks.destroy.success")
  end

  # email registration for task
  def register
    @task = Task.find(params[:id])
    if user_signed_in?
      UserMailer.with(task: @task, user: current_user).task_registration_email.deliver_now
      redirect_to @task, notice: "Du har anmält dig till uppdraget!"
    else
      redirect_to @task, alert: "Du måste vara inloggad för att anmäla dig."
    end
  end

  before_action :find_or_create_category, only: [:create, :update]

  private

  def set_task
    @task = Task.find(params[:id])
  end

  def task_params
    params.require(:task).permit(:title, :company, :city, :description)
  end
  
  def correct_user
    @task = current_user.tasks.find_by(id: params[:id])
    redirect_to tasks_path, notice: "Not authorized to edit this task" if @task.nil?
  end

  def find_or_create_category
    if params[:task][:new_category_name].present?
      category_name = params[:task][:new_category_name]
      category = Category.find_or_create_by(name: category_name)
      params[:task][:category_ids] ||= []
      params[:task][:category_ids] << category.id
    end
  end

  def task_params
    params.require(:task).permit(:title, :company, :city, :description, category_ids: [])
  end
end