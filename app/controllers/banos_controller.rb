require "operacionGps.rb"

class BanosController < ApplicationController
  # before_action :set_bano, only: [:show, :edit, :update, :destroy]

  skip_before_filter :verify_authenticity_token  

  swagger_controller :banos, "Baños"

  swagger_api :crearPunto do
    summary "Crear posición de los baños"
    param :form, :latitud, :float, :required, "Latitud"
    param :form, :longitud, :float, :required, "Longitud"
    param :form, :descripcion, :string, :required, "Descripción"
    response :json
    response :not_acceptable
  end

  swagger_api :obtieneTodos do
    summary "Obtiene todos los baños"
    response :json
    response :not_acceptable
  end

  swagger_api :modificaBaño do
    summary "Modifica la posicion de un baño"
    param :form, :latitud, :float, :required, "Latitud"
    param :form, :longitud, :float, :required, "Longitud"
    param :form, :descripcion, :string, :required, "Descripción"
    response :json
    response :not_acceptable
  end

  def crearPunto

    latitud = params[:latitud]
    longitud = params[:longitud]
    descripcion = params[:descripcion]

    logger.info("LATITUD: #{latitud}") 
    logger.info("LONGITUD: #{longitud}")
    logger.info("DESCRIPCION: #{descripcion}")

    operacionGps = OperacionGps.new

    zonaHor = operacionGps.calculaZonaHoraria(longitud)

    @banoNuevo = Bano.new
    @banoNuevo.latitud = latitud
    @banoNuevo.longitud = longitud
    @banoNuevo.descripcion = descripcion
    @banoNuevo.zonaHoraria = zonaHor

    if @banoNuevo.save 
      logger.info("SE GUARDO CORRECTAMENTE")
    else
      logger.info("NO SE PUDO GURDAR")
    end


    render :json => {result:"Success"}, :status => 200

  end


  def obtieneTodos
    @banos = Bano.all
    render :json => @banos.to_json, :callback => params['callback'], :status => 200
  end


  def modificaBaño

    latitud = params[:latitud]
    longitud = params[:longitud]
    descripcion = params[:descripcion]

    logger.info("LATITUD: #{latitud}") 
    logger.info("LONGITUD: #{longitud}")
    logger.info("DESCRIPCION: #{descripcion}")

    operacionGps = OperacionGps.new

    zonaHor = operacionGps.calculaZonaHoraria(longitud)

    @bano.update(bano_params)

  end








  # GET /banos
  # GET /banos.json
  def index
    @banos = Bano.all
  end

  # GET /banos/1
  # GET /banos/1.json
  def show
  end

  # GET /banos/new
  def new
    @bano = Bano.new
  end

  # GET /banos/1/edit
  def edit
  end

  # POST /banos
  # POST /banos.json
  def create
    @bano = Bano.new(bano_params)

    respond_to do |format|
      if @bano.save
        format.html { redirect_to @bano, notice: 'Bano was successfully created.' }
        format.json { render action: 'show', status: :created, location: @bano }
      else
        format.html { render action: 'new' }
        format.json { render json: @bano.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /banos/1
  # PATCH/PUT /banos/1.json
  def update
    respond_to do |format|
      if @bano.update(bano_params)
        format.html { redirect_to @bano, notice: 'Bano was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @bano.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /banos/1
  # DELETE /banos/1.json
  def destroy
    @bano.destroy
    respond_to do |format|
      format.html { redirect_to banos_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_bano
      @bano = Bano.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def bano_params
      params.require(:bano).permit(:descripcion, :latitud, :longitud)
    end
end
