class QuestionsController < ApplicationController
  def new
  end

  def create
    @question = Question.new(params.require(:questions).permit(:question, :answer, :parent_id))
    @question.save
    redirect_to @question
  end

  def show
    @question = Question.find(params[:id])
  end

  def index
    @top_level = Question.where(parent_id: nil).includes(:children)
  end
end
