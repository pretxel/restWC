class CoordenadaController < ApplicationController

	skip_before_filter :verify_authenticity_token  

	swagger_controller :coordenada, "Coordenadas"

	  swagger_api :obtieneCercanos do
	    summary "Crear posición de los baños"
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

    	if !distanciaParam
    		distanciaParam = 5
    	end

         zonaHorariaCons = calculaZonaHoraria(longitud)

    	if distanciaParam.to_i > 0
    		
            #Obtener las ubicaciones con respecto a la zona horaria
	    	@Banos = Bano.where(zonaHoraria: zonaHorariaCons)
	    	# @Banos = Bano.all
            filtroBanos = Array.new

	    	@Banos.each do |bano|
	    		logger.info("#{bano.descripcion}")
	    		distancia = calculaDistancia(latitud, longitud, bano.latitud, bano.longitud)
	    		logger.info("#{distancia}")

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


	def calculaDistancia(latitudO,longitudO, latitudD, longitudD) 

		# latitud = params[:latitud]
  #   	longitud = params[:longitud]


    	#Obtengo varios puntos que comparar

    	# latitud = 19.2967179
    	# longitud =  -99.1860864


    	# latitud2 = 19.4208037
    	# longitud2 =  -99.0841608

    	#Se covierte a radianes

    	latitudR = latitudO.to_f * (Math::PI / 180);
    	longitudR = longitudO.to_f * (Math::PI / 180);


    	latitudR2 = latitudD * (Math::PI / 180);
    	longitudR2 = longitudD * (Math::PI / 180);


    	#Deltas de latitud y longitud

    	deltaLatitud = latitudR.to_f - latitudR2.to_f
    	deltaLongitud = longitudR.to_f - longitudR2.to_f


    	a1 = Math.sin(deltaLatitud/2)**2
    	a2 = Math.sin(deltaLongitud/2)**2


    	atotal = a1 + Math.cos(latitudR.to_f) * Math.cos(latitudR2.to_f) * a2;

    	c = 2 * Math.atan2(Math.sqrt(atotal), Math.sqrt(1-atotal))

    	d = 6371 * c;

    	logger.info("DISTANCIA : #{d}")
    	return d
	end

    def calculaZonaHoraria(longitud)
     zonaHoraria = longitud.to_f / 15
     return zonaHoraria.to_i
  end


end