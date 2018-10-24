class TextsController < ApplicationController
  skip_before_action :verify_authenticity_token

  api :POST, '/text/expand_pointer', 'Expands a pointer. For example, if the topmost text is "what is the sum of #1?" and `number` is 1, then this will be expanded to "what is the sum of [pointer information]?"'
  param :id, :number, :desc => 'Id of the topmost text'
  param :number, :number, :desc => 'Number of the pointer to expand'
  def expand_pointer
    text = Text.find(params[:id])
    text.assign_counters
    pointer = text.find_pointer(params[:number].to_i)
    raise "#{params[:id]} does not have a pointer #{params[:number]}" if pointer.blank?
    pointer.expanded = true
    pointer.save!
    text.reload
    text.assign_counters
    render json: text.as_json
  end

  api :GET, '/text/:id'
  param :id, :number
  def show
    @text = Text.find(params[:id])
    render json: @text.as_json
  end
end
