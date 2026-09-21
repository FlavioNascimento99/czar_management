module Api
  module V1
    class ProjectsController < BaseController
      def index
        projects = current_api_user.projects.order(:name)
        render json: projects.map { |p| { id: p.id, name: p.name, description: p.description } }
      end

      def show
        project = current_api_user.projects.find(params[:id])
        render json: {
          id: project.id, name: project.name, description: project.description,
          tasks_count: project.tasks.count,
          tasks: project.tasks.order(:created_at).limit(50).map { |t| task_json(t) }
        }
      rescue ActiveRecord::RecordNotFound
        render json: { error: "Projeto não encontrado" }, status: :not_found
      end

      private

      def task_json(t)
        { id: t.id, title: t.title, status: t.status, priority: t.priority, due_date: t.due_date, assigned_to_id: t.assigned_to_id }
      end
    end
  end
end
