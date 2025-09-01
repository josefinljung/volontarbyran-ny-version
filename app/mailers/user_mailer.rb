class UserMailer < ApplicationMailer
  default from: 'volantarbyran@email.com'

  def task_registration_email
    @task = params[:task]
    @user = params[:user]
    mail(to: 'mottagare@email.com', subject: "Anmälan till uppdrag : #{@task.title}")
  end
end