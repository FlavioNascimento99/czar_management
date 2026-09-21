module Api
  module V1
    class TasksController < BaseController
      before_action :set_project

      def index
        tasks = @project.tasks.includes(:assigned_to).ordered_by_due.limit(100)
        tasks = tasks.where(status: params[:status]) if Task.statuses.key?(params[:status].to_s)
        render json: tasks.map { |t| task_json(t) }
      end

      def show
        task = @project.tasks.find(params[:id])
        render json: task_json(task)
      rescue ActiveRecord::RecordNotFound
        render json: { error: "Tarefa não encontrada" }, status: :not_found
      end

      def update
        task = @project.tasks.find(params[:id])
        if task.update(task_api_params)
          render json: task_json(task)
        else
          render json: { errors: task.errors.full_messages }, status: :unprocessable_entity
        end
      rescue ActiveRecord::RecordNotFound
        render json: { error: "Tarefa não encontrada" }, status: :not_found
      rescue ArgumentError
        render json: { error: "Status ou prioridade inválidos" }, status: :unprocessable_entity
      end

      private

      def set_project
        @project = current_api_user.projects.find(params[:project_id])
      rescue ActiveRecord::RecordNotFound
        render json: { error: "Projeto não encontrado" }, status: :not_found
      end

      def task_api_params
        params.require(:task).permit(:status, :priority, :assigned_to_id, :due_date, :recurrence, :title, :description)
      end

      def task_json(t)
        { id: t.id, project_id: t.project_id, title: t.title, description: t.description, status: t.status, priority: t.priority, due_date: t.due_date, assigned_to_id: t.assigned_to_id }
      end
    end
  end
end
