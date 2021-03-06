class QuestionsController < ApplicationController
  include ActionView::Helpers::DateHelper
  before_action :load_commentable
  before_action :set_question, only: [:show, :destroy]
  before_action :set_vote_value, only: [:vote]
  before_action :correct_user, only: [:update]

  # GET /questions/1
  # GET /questions/1.json
  def show
    @idea    = @question.idea
    @answers = @question.answers.includes(:user)
    @time    = time_ago_in_words(@question.created_at)
    @answer  = Answer.new
    @comment = @commentable.comments.new
    
    render layout: 'sidebar_left'
  end

  # GET /questions/new
  def new
    @question = Question.new
    @idea = Idea.find(params[:id])
  end

  # POST /questions
  # POST /questions.json
  def create
    @question = Question.new(question_params)
    @question.idea_id = params[:id]
    @question.user = current_user

    respond_to do |format|
      if @question.save
        @question.create_activity :create, owner: (current_user)
        format.html { redirect_to @question, notice: 'Question was successfully created.' }
        format.json { render action: 'show', status: :created, location: @question }
        if not current_user.following_idea?(@question.idea)
          current_user.follow_idea!(@question.idea)
        end
      else
        format.html { render action: 'new' }
        format.json { render json: @question.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /questions/1
  # PATCH/PUT /questions/1.json
  def update
    @question = Question.find(params[:question_id])
    respond_to do |format|
      if @question.update(question_params)
        @question.create_activity :update, owner: (current_user)
        format.html { redirect_to @question, notice: 'Question was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @question.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /questions/1
  # DELETE /questions/1.json
  def destroy
    @question.destroy
    respond_to do |format|
      format.html { redirect_to questions_url }
      format.json { head :no_content }
    end
  end

  def vote
    @voteable = Question.find(params[:voteable_id])
    @voteable.update_lab_evaluation(@value, current_user) unless current_user == nil
    respond_to do |format|
      format.html {redirect_to :back, notice: "Vote submitted"}
      format.js {render template: 'evaluations/vote'}
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_question
      @question = Question.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def question_params
      params.require(:question).permit(:title, :brief, :idea_id, :user_id)
    end

    def correct_user
      unless current_user == @question.user then
        redirect_to @question, notice: "You do not have permission to edit this question."
      end
    end
end
