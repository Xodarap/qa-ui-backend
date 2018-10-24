class QuestionsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def new
  end

  api :POST, '/questions', 'create a new question'
  param 'question', String, :desc => "Question text, possibly including pointers in square brackets", :required => true
  param 'answer', String, :desc => "Answer text, possibly including pointers in square brackets", :required => false
  param 'parent_id', :number, :desc => "Parent question ID", :required => false
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

  api :PATCH, '/questions/:id', 'Update a question. If a parameter is left false or if its value is unchanged, no modifications will be made'
  param :id, :number
  param 'question', String, :desc => "Question text, possibly including pointers in square brackets", :required => false
  param 'answer', String, :desc => "Answer text, possibly including pointers in square brackets", :required => false
  param 'parent_id', :number, :desc => "Parent question ID", :required => false
  def update
    @question = Question.find(params[:id])
    [:question, :answer].each {|property| set_property(@question, property)}
    @question.parent_id = safe_parameters[:parent_id] if safe_parameters.key?(:parent_id)
    @question.save!
    render json: @question.as_json
  end

  api :DELETE, '/questions/:id', 'Deletes question. Note that the delete cascades and also removes any child questions.'
  param :id, :number
  def destroy
    @question = Question.find(params[:id])
    @question.destroy_cascade
    head :ok
  end

  private
  def safe_parameters
    params.permit(:question, :answer, :parent_id)
  end

  def set_property(question, property)
    return unless safe_parameters.key?(property)
    return if question.send(property).display == safe_parameters[property]

    new_text = Text.build_text(safe_parameters[property])
    question.send("#{property}=", new_text)
  end
end
