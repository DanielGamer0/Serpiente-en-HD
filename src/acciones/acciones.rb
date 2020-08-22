# frozen_string_literal: true

module Acciones
  def self.mover_serpiente(actual_estado)
    # proxima_direccion = estado_actual.direccion_actual
    proxima_posicion = calcular_siguiente_posicion(actual_estado)
    if es_posicion_comida?(proxima_posicion, actual_estado.comida)
      crecer_serpiente_en(proxima_posicion, actual_estado)
      generar_comida(actual_estado)
    elsif es_posicion_valida?(proxima_posicion, actual_estado)
      mover_serpiente_a(proxima_posicion, actual_estado)
    else
      terminar_juego(actual_estado)
    end
  end

  def self.cambiar_direccion(actual_estado, direccion_entrada)
    if es_siguiente_direccion_valida?(actual_estado, direccion_entrada)
      actual_estado.direccion_actual = direccion_entrada
    else
      puts '❌: Dirección inválida 🔄' + "(#{direccion_entrada})"
    end
    actual_estado
  end

  def self.calcular_siguiente_posicion(estado_actual)
    actual_posicion = estado_actual.serpiente.posiciones.first
    case estado_actual.direccion_actual
    when Modelo::Direccion::ARRIBA
      # decrementar fila
      Modelo::Coordenada.new(
        actual_posicion.columna,
        actual_posicion.fila - 1
      )
    when Modelo::Direccion::ABAJO
      # incrementar fila
      Modelo::Coordenada.new(
        actual_posicion.columna,
        actual_posicion.fila + 1
      )
    when Modelo::Direccion::IZQUIERDA
      # decrementar columna
      Modelo::Coordenada.new(
        actual_posicion.columna - 1,
        actual_posicion.fila
      )
    when Modelo::Direccion::DERECHA
      # incrementar columna
      Modelo::Coordenada.new(
        actual_posicion.columna + 1,
        actual_posicion.fila
      )
    end
  end

  def self.es_posicion_valida?(siguente_posicion, estado_actual)
    # verificar que la serpiente esté en la cuadrícula
    es_invalida = siguente_posicion.fila >= estado_actual.cuadricula.filas ||
                  siguente_posicion.fila.negative? ||
                  siguente_posicion.columna >= estado_actual.cuadricula.columnas ||
                  siguente_posicion.columna.negative?
    return false if es_invalida

    # verificar que la serpiente no se esté superponiendo
    !(estado_actual.serpiente.posiciones.include? siguente_posicion)
  end

  def self.mover_serpiente_a(siguiente_posicion, estado_actual)
    # actual_estado.serpiente.posiciones[0...-1] == actual_estado.posiciones[0]...actual_estado.serpiente.posiciones[-1]
    nuevas_posiciones = [siguiente_posicion] + estado_actual.serpiente.posiciones[0...-1]
    estado_actual.serpiente.posiciones = nuevas_posiciones
    estado_actual
  end

  def self.terminar_juego(estado_final)
    estado_final.game_over = true
    puts '🕹 Game Over ⚰'
    estado_final
  end

  def self.es_siguiente_direccion_valida?(estado_actual, direccion_entrante)
    case estado_actual.direccion_actual
    when Modelo::Direccion::ARRIBA
      return true unless direccion_entrante == Modelo::Direccion::ABAJO
    when Modelo::Direccion::ABAJO
      return true unless direccion_entrante == Modelo::Direccion::ARRIBA
    when Modelo::Direccion::DERECHA
      return true unless direccion_entrante == Modelo::Direccion::IZQUIERDA
    when Modelo::Direccion::IZQUIERDA
      return true unless direccion_entrante == Modelo::Direccion::DERECHA
    else
      false
    end
  end

  def self.es_posicion_comida?(siguiente_posicion, estado_comida)
    estado_comida.columna - 0.5 == siguiente_posicion.columna && estado_comida.fila - 0.5 == siguiente_posicion.fila
  end

  def self.crecer_serpiente_en(posicion_comida, estado_actual)
    nuevas_posiciones = [posicion_comida] + estado_actual.serpiente.posiciones
    estado_actual.serpiente.posiciones = nuevas_posiciones
    estado_actual
  end

  def self.generar_comida(estado_actual)
    columnas_invalidas = estado_actual.serpiente.posiciones.map { |posicion| posicion.columna + 0.5 }
    # puts "columnas inválidas: #{columnas_invalidas}"
    filas_invalidas = estado_actual.serpiente.posiciones.map { |posicion| posicion.fila + 0.5 }
    # puts "filas inválidas: #{filas_invalidas}"
    nueva_comida = Modelo::Comida.new
    loop do
      nueva_comida = Modelo::Comida.new(rand(estado_actual.cuadricula.columnas) + 0.5, rand(estado_actual.cuadricula.filas) + 0.5)
      break unless columnas_invalidas.include?(nueva_comida.columna) || filas_invalidas.include?(nueva_comida.fila)
    end
    estado_actual.comida = nueva_comida
    estado_actual
  end
end
