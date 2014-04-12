class OperacionGps 


def initialize()
	end

	def calculaZonaHoraria(longitud)
     zonaHoraria = longitud.to_f / 15
     return zonaHoraria.to_i
  end


  def calculaDistancia(latitudO,longitudO, latitudD, longitudD) 

	

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

    	return d
	end



end