from validacion import validaCadena, validaEntero, validaPlaca, validaSiNo, validaOpcion, mensaje

class Vehiculo:
    _contador = 0
    def __init__(self, marca, placa, capacidad):
        self.__marca = marca
        self.__placa = placa
        self.__capacidad = capacidad
        self.__conductorAsignado = None
        self.__rutaAsignada = None
        self.codigoVehiculo = self.generaCodigo()
        self.__class__.setContador(self.__class__.getContador()+1)

    #getters
    def getMarca(self):
        return self.__marca
    def getPlaca(self):
        return self.__placa
    def getCapacidad(self):
        return self.__capacidad
    def getConductorAsignado(self):
        return self.__conductorAsignado
    def getRutaAsignada(self):
        return self.__rutaAsignada

    #setters
    def setMarca(self, marca):
        self.__marca = marca
    def setPlaca(self, placa):
        self.__placa = placa
    def setCapacidad(self, capacidad):
        self.__capacidad = capacidad
    def setConductorAsignado(self, conductor):
        self.__conductorAsignado = conductor
    def setRutaAsignada(self, ruta):
        self.__rutaAsignada = ruta

    #properties
    marca = property(getMarca, setMarca)
    placa = property(getPlaca, setPlaca)
    capacidad = property(getCapacidad, setCapacidad)
    conductorAsignado = property(getConductorAsignado, setConductorAsignado)
    rutaAsignada = property(getRutaAsignada, setRutaAsignada)
    
    @classmethod
    def getContador(cls):
        return cls._contador
    @classmethod
    def setContador(cls, valor):
        cls._contador = valor

    def generaCodigo(self):
        contador = self.__class__.getContador()
        if contador < 10:
            return f"V00{contador}"
        elif contador < 100:
            return f"V0{contador}"
        elif contador < 1000:
            return f"V{contador}"
        else:
            return "ERROR: MAX"
    
    def registro(self):
        print("\n=== REGISTRO DE VEHÍCULO ===")
        marca = validaCadena(2, 30, "Ingrese marca del vehículo: ")
        placa = validaPlaca("Ingrese placa del vehículo: ")
        capacidad = validaEntero(5, 60, "Ingrese capacidad del vehículo: ")
        
        self.__init__(marca, placa, capacidad)
        mensaje("exito", f"Vehículo {marca} con placa {placa} registrado con código {self.codigoVehiculo}")
    
    def eliminar(self):
        print(f"\n=== ELIMINAR VEHÍCULO ===")
        print(f"Vehículo: {self.marca} - Placa: {self.placa}")
        print(f"Código: {self.codigoVehiculo}")
        if self.conductorAsignado:
            mensaje("advertencia", f"Este vehículo tiene asignado al conductor {self.conductorAsignado.codigoConductor}")
        confirmacion = validaSiNo("¿Está seguro de eliminar este vehículo?")
        if confirmacion:
            mensaje("exito", f"Vehículo {self.codigoVehiculo} eliminado correctamente")
            return True
        else:
            mensaje("advertencia", "Operación cancelada")
            return False
    
    def actualizar(self):
        print(f"\n=== ACTUALIZAR VEHÍCULO ===")
        print(f"Vehículo actual: {self.marca} - {self.placa}")
        
        opciones = ["Marca", "Capacidad", "Salir"]
        while True:
            opcion = validaOpcion(opciones, "\n¿Qué desea actualizar?")
            
            if opcion == 1:
                nuevaMarca = validaCadena(2, 30, "Ingrese nueva marca: ")
                self.setMarca(nuevaMarca)
                mensaje("exito", "Marca actualizada")
            elif opcion == 2:
                nuevaCapacidad = validaEntero(5, 60, "Ingrese nueva capacidad: ")
                self.setCapacidad(nuevaCapacidad)
                mensaje("exito", "Capacidad actualizada")
            elif opcion == 3:
                mensaje("exito", "Actualización completada")
                break

    def __str__(self):
        conductorInfo = f"Conductor: {self.conductorAsignado.codigoConductor}" if self.conductorAsignado else "Sin conductor"
        return f"VEHÍCULO: ({self.codigoVehiculo}) {self.marca} - Placa: {self.placa}, Capacidad: {self.capacidad}, {conductorInfo}"