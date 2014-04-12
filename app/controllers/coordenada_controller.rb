require "operacionGps.rb"
class CoordenadaController < ApplicationController

	skip_before_filter :verify_authenticity_token  

	swagger_controller :coordenada, "Coordenadas"

	  swagger_api :obtieneCercanos do
	    summary "Obtiene los baños mas cercanos dependiendo de la posición"
	    param :form, :latitud, :string, :required, "Latitud"
	    param :form, :longitud, :string, :required, "Longitud"
	    param :form, :distancia, :string, "Distancia"
	    response :json
	    response :not_acceptable
	  end


	  def obtieneCercanos 

	  	latitud = params[:latitud]
    	longitud = params[:longitud]
    	distanciaParam = params[:distancia]
        operacionGps = OperacionGps.new

    	if !distanciaParam
    		distanciaParam = 5
    	end

         zonaHorariaCons = operacionGps.calculaZonaHoraria(longitud)

    	if distanciaParam.to_i > 0
    		
            #Obtener las ubicaciones con respecto a la zona horaria
	    	@Banos = Bano.where(zonaHoraria: zonaHorariaCons)
	    	# @Banos = Bano.all
            filtroBanos = Array.new

	    	@Banos.each do |bano|
	    		logger.info("Descripcion del Lugar : #{bano.descripcion}")
	    		distancia = operacionGps.calculaDistancia(latitud, longitud, bano.latitud, bano.longitud)
	    		logger.info("Distancia : #{distancia} kilometros")

	    		if distancia <= distanciaParam.to_i
	    			filtroBanos << bano
	    		end

	    	end

    	else
    		filtroBanos = "Distancia no permitida"
    	end

    	# logger.info("Todos los baños : #{@Banos}")

    	# distancia = calculaDistancia(latitud, longitud)


	  	render :json => {result: filtroBanos}, :status => 200
	  end


	


end