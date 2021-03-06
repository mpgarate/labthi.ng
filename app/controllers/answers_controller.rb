class AnswersController < ApplicationController
  before_action :set_answer, only: [:show, :edit, :update, :destroy]
  before_action :set_question, only: [:new]
  before_action :set_vote_value, only: [:vote]

  # GET /answers/1
  # GET /answers/1.json
  def show
    redirect_to @answer.question
  end

  # GET /answers/new
  def new
    @answer = Answer.new
  end

  # GET /answers/1/edit
  def edit
  end

  # POST /answers
  # POST /answers.json
  def create
    @answer = Answer.new(answer_params)
    @answer.question_id = params[:question_id]
    @answer.user = current_user

    respond_to do |format|
      if @answer.save
        @answer.create_activity :create, owner: (current_user)
        format.html { redirect_to @answer.question, notice: 'Answer was successfully created.' }
        format.json { render action: 'show', status: :created, location: @answer }
        #format.js {render template: 'answers/create'}
        if not current_user.following_idea?(@answer.question.idea)
          current_user.follow_idea!(@answer.question.idea)
        end
      else
        format.html { render action: 'new' }
        format.json { render json: @answer.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /answers/1
  # PATCH/PUT /answers/1.json
  def update
    respond_to do |format|
      if @answer.update(answer_params)
        @answer.create_activity :update, owner: (current_user)
        format.html { redirect_to @answer.question, notice: 'Answer was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @answer.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /answers/1
  # DELETE /answers/1.json
  def destroy
    @answer.destroy
    respond_to do |format|
      format.html { redirect_to answers_url }
      format.json { head :no_content }
    end
  end

  def vote
    @voteable = Answer.find(params[:voteable_id])
    @voteable.update_lab_evaluation(@value, current_user) unless current_user == nil
    respond_to do |format|
      format.html {redirect_to :back, notice: "Vote submitted"}
      format.js {render template: 'evaluations/vote'}
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_answer
      @answer = Answer.find(params[:id])
    end

    def set_question
      @question = Question.find(params[:question_id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def answer_params
      params.require(:answer).permit(:brief, :user_id, :question_id)
    end
end
