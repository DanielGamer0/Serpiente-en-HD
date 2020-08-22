require 'ruby2d'

module Vista
  class VistaRuby2d
    def initialize(instancia_aplicacion)
      @tamanno_pixel = 80
      @aplicacion = instancia_aplicacion
    end

    def iniciar(estado_inicio)
      extend Ruby2D::DSL # Domain-Specific Language
      set(
        title: 'La🐍enHD',
        width: @tamanno_pixel * estado_inicio.cuadricula.columnas,
        height: @tamanno_pixel * estado_inicio.cuadricula.filas
      )
      on(:key_down) { |tecla| manejar_evento_tecleo(tecla) }
      show
    end

    def renderizar(estado)
      extend Ruby2D::DSL
      close if estado.game_over
      renderizar_comida(estado.comida)
      renderizar_serpiente(estado.serpiente)
    end

    private

    def renderizar_comida(estado_comida)
      @vista_comida&.remove # @vista_comida.remove if @vista_comida
      extend Ruby2D::DSL
      @vista_comida = Circle.new(
        x: estado_comida.columna * @tamanno_pixel,
        y: estado_comida.fila * @tamanno_pixel,
        radius: @tamanno_pixel / 2,
        sectors: 32,
        color: 'yellow',
        z: 10
      )
    end

    def renderizar_serpiente(estado_serpiente)
      # @posiciones_serpiente.each { |posicion| posicion.remove } if @posiciones_serpiente
      @posiciones_serpiente&.each(&:remove)
      extend Ruby2D::DSL
      @posiciones_serpiente = estado_serpiente.posiciones.map do |posicion|
        Square.new(
          x: posicion.columna * @tamanno_pixel,
          y: posicion.fila * @tamanno_pixel,
          size: @tamanno_pixel,
          color: 'olive',
          z: 10
        )
      end
    end

    def manejar_evento_tecleo(evento)
      case evento.key
      when 'up'
        @aplicacion.enviar_accion(:cambiar_direccion, Modelo::Direccion::ARRIBA)
      when 'down'
        @aplicacion.enviar_accion(:cambiar_direccion, Modelo::Direccion::ABAJO)
      when 'left'
        @aplicacion.enviar_accion(:cambiar_direccion, Modelo::Direccion::IZQUIERDA)
      when 'right'
        @aplicacion.enviar_accion(:cambiar_direccion, Modelo::Direccion::DERECHA)
      else
        puts '❌: Tecla inválida ⌨' + "(#{evento.key})"
      end
    end
  end
end
