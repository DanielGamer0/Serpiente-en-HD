require_relative 'vista/ruby2d'
require_relative 'modelo/estado'
require_relative 'acciones/acciones'

class Aplicacion
  def initialize
    @estado = Modelo::estado_inicial
  end

  def start
    @vista = Vista::VistaRuby2d.new(self)
    hilo_temporizador = Thread.new { iniciar_temporizador(@vista) }
    @vista.iniciar(@estado)
    hilo_temporizador.join
  end

  def iniciar_temporizador(vista)
    loop do
      if @estado.game_over
        puts "Comida de 🐍: #{@estado.serpiente.posiciones.length - 2}"
        break
      end
      @estado = Acciones::mover_serpiente(@estado)
      vista.renderizar(@estado)
      sleep 0.25
    end
  end

  def enviar_accion(accion, parametros)
    nuevo_estado = Acciones.send(accion, @estado, parametros)
    unless nuevo_estado.hash == @estado.hash
      @estado = nuevo_estado
      @vista.renderizar(@estado)
    end
  end
end

aplicacion = Aplicacion.new
aplicacion.start