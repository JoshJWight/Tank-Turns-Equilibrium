class BotsController < ApplicationController
  def new
    @bot = Bot.new
  end

  def index
    @bots = Bot.all
  end

  def create
    @bot = Bot.new(bot_params)
    @bot.population = 0
    if @bot.save
      redirect_to @bot
    else
      render 'new'
    end
  end

  def edit
    @bot = Bot.find(params[:id])
  end

  def update
    @bot = Bot.find(params[:id])

    if @bot.update(bot_params)
      redirect_to @bot
    else
      render 'edit'
    end
  end

  def show
    @bot = Bot.find(params[:id])
  end

  def destroy
    @bot = Bot.find(params[:id])
    @bot.destroy

    redirect_to bots_path
  end

  def populate
    @bot = Bot.find(params[:id])
    @bot.population += 10
    @bot.save
    redirect_to bots_path
  end

private
  def bot_params
    params[:bot].permit(:name, :code, :population)
  end

end
