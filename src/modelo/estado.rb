# Representación del estado del juego

module Modelo
  module Direccion
    ARRIBA = :arriba
    ABAJO = :abajo
    IZQUIERDA = :izquierda
    DERECHA = :derecha
  end

  Coordenada = Struct.new(:columna, :fila) do
  end

  class Comida < Coordenada # Herencia de Coordenada
  end

  Serpiente = Struct.new(:posiciones) do
  end

  Cuadricula = Struct.new(:columnas, :filas) do
  end

  Estado = Struct.new(:cuadricula, :comida, :serpiente, :direccion_actual, :game_over) do
  end

  def self.estado_inicial
    Modelo::Estado.new(
      Modelo::Cuadricula.new(16, 9),
      Modelo::Comida.new(4.5, 4.5),
      Modelo::Serpiente.new(
        [
          Modelo::Coordenada.new(2, 1),
          Modelo::Coordenada.new(1, 1)
        ]
      ),
      Direccion::DERECHA,
      false
    )
  end
end
