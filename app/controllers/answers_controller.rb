class AnswersController < ApplicationController
  before_action :set_answer, only: [:show, :edit, :update, :destroy]
  before_action :set_problem, only: [:index, :new, :edit, :update]

  # GET /answers
  # GET /answers.json
  def index
    @answers = @problem.answers
  end

  # GET /answers/1
  # GET /answers/1.json
  def show
  end

  # GET /answers/new
  def new
    @answer = Answer.new(problem: @problem)
  end

  # GET /answers/1/edit
  def edit
  end

  # POST /answers
  # POST /answers.json
  def create
    @answer = Answer.new(answer_params)
    @answer.city = current_user.city
    @problem = @answer.problem

    respond_to do |format|
      if @answer.save
        format.html { redirect_to root_path, notice: I18n.t('notice.success.create', model: Answer.model_name.human) }
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
        result = @answer.result
        if result.present? && !result.valid_answer
          result.destroy
        end
        format.html { redirect_to root_path, notice: I18n.t('notice.success.update', model: Answer.model_name.human) }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @answer.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_answer
      @answer = Answer.find(params[:id])
    end

    def set_problem
      @problem = params[:problem_id] ? Problem.find(params[:problem_id]) : @answer.problem
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def answer_params
      params.require(:answer).permit(:text, :problem_id)
    end
end
