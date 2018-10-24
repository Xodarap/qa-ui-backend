class QuestionsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def new
  end

  api :POST, '/questions', 'create a new question'
  param :questions, Hash do
    param 'question', String, :desc => "Question text, possibly including pointers in square brackets", :required => true
    param 'answer', String, :desc => "Answer text, possibly including pointers in square brackets", :required => false
    param 'parent_id', :number, :desc => "Parent question ID", :required => false
  end
  def create
    question_text = Text.build_text(safe_parameters[:question])
    answer_text = Text.build_text(safe_parameters[:answer]) if safe_parameters[:answer].present?
    @question = Question.new(parent_id: safe_parameters[:parent_id],
      question: question_text, answer: answer_text)
    @question.save
    respond_to do |format|
      format.html { redirect_to @question }
      format.js { render json: @question.as_json }
    end    
  end

  api :GET, '/questions/:id', 'Show an existing question'
  param :id, :number
  def show
    @question = Question.find(params[:id])
    respond_to do |format|
      format.html 
      format.js { render json: @question.as_json }
    end
  end

  api :GET, '/questions', 'Show all top-level questions'
  returns :code => 200, :desc => 'all top-level questions (i.e. all questions with no parent ID)'
  def index
    @top_level = Question.where(parent_id: nil).includes(:children)
    respond_to do |format|
      format.html 
      format.js { render json: @top_level.map(&:as_json) }
    end
  end

  private
  def safe_parameters
    params.require(:questions).permit(:question, :answer, :parent_id)
  end
end
