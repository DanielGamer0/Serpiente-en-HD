require 'minitest/autorun'
require 'minitest/mock'
require_relative '../src/modelo/estado'
require_relative '../src/acciones/acciones'

class TestDeAcciones < Minitest::Test
  def setup
    @estado_inicial =
      Modelo::Estado.new(
        Modelo::Cuadricula.new(16, 9),
        Modelo::Comida.new(4, 4),
        Modelo::Serpiente.new(
          [
            Modelo::Coordenada.new(2, 1),
            Modelo::Coordenada.new(1, 1)
          ]
        ),
        Modelo::Direccion::DERECHA,
        false
      )
  end

  def test_movimineto_serpiente
    estado_esperado =
      Modelo::Estado.new(
        Modelo::Cuadricula.new(16, 9),
        Modelo::Comida.new(4, 4),
        Modelo::Serpiente.new(
          [
            Modelo::Coordenada.new(3, 1),
            Modelo::Coordenada.new(2, 1)
          ]
        ),
        Modelo::Direccion::DERECHA,
        false
      )
    estado_resultante = Acciones.mover_serpiente(@estado_inicial)
    assert_equal estado_esperado, estado_resultante
  end

  def test_invalidacion_cambio_direccion
    estado_esperado =
      Modelo::Estado.new(
        Modelo::Cuadricula.new(16, 9),
        Modelo::Comida.new(4, 4),
        Modelo::Serpiente.new(
          [
            Modelo::Coordenada.new(2, 1),
            Modelo::Coordenada.new(1, 1)
          ]
        ),
        Modelo::Direccion::DERECHA,
        false
      )
    estado_resultante = Acciones.cambiar_direccion(@estado_inicial, Modelo::Direccion::IZQUIERDA)
    assert_equal estado_esperado, estado_resultante
  end

  def test_validacion_cambio_direccion
    estado_esperado =
      Modelo::Estado.new(
        Modelo::Cuadricula.new(16, 9),
        Modelo::Comida.new(4, 4),
        Modelo::Serpiente.new(
          [
            Modelo::Coordenada.new(2, 1),
            Modelo::Coordenada.new(1, 1)
          ]
        ),
        Modelo::Direccion::ABAJO,
        false
      )
    estado_resultante = Acciones.cambiar_direccion(@estado_inicial, Modelo::Direccion::ABAJO)
    assert_equal estado_esperado, estado_resultante
  end

  def test_crecimiento_serpiente
    estado_inicio =
      Modelo::Estado.new(
        Modelo::Cuadricula.new(16, 9),
        Modelo::Comida.new(3.5, 1.5),
        Modelo::Serpiente.new(
          [
            Modelo::Coordenada.new(2, 1),
            Modelo::Coordenada.new(1, 1)
          ]
        ),
        Modelo::Direccion::DERECHA,
        false
      )

    estado_resultante = Acciones.mover_serpiente(estado_inicio)
    assert_equal [Modelo::Coordenada.new(3, 1),
                  Modelo::Coordenada.new(2, 1),
                  Modelo::Coordenada.new(1, 1)],
                 estado_resultante.serpiente.posiciones
  end

  def test_generacion_comida
    estado_inicio =
      Modelo::Estado.new(
        Modelo::Cuadricula.new(16, 9),
        Modelo::Comida.new(3.5, 1.5),
        Modelo::Serpiente.new(
          [
            Modelo::Coordenada.new(2, 1),
            Modelo::Coordenada.new(1, 1)
          ]
        ),
        Modelo::Direccion::DERECHA,
        false
      )
    estado_esperado =
      Modelo::Estado.new(
        Modelo::Cuadricula.new(16, 9),
        Modelo::Comida.new(0.5, 0.5),
        Modelo::Serpiente.new(
          [
            Modelo::Coordenada.new(3, 1),
            Modelo::Coordenada.new(2, 1),
            Modelo::Coordenada.new(1, 1)
          ]
        ),
        Modelo::Direccion::DERECHA,
        false
      )
    Acciones.stub(:rand, 0) do # Determina el comportamiento del método rand()
      estado_resultante = Acciones.mover_serpiente(estado_inicio)
      assert_equal estado_esperado, estado_resultante
    end
  end
end
