from validacion import validaCadena, validaFlotante, validaSiNo, validaOpcion, mensaje

class Ruta:
    _contador = 0
    def __init__(self, nombre, tarifaMensual):
        self.__nombre = nombre
        self.__tarifaMensual = tarifaMensual
        self.__estudiantes = []
        self.__vehiculoAsignado = None
        self.__conductorAsignado = None
        self.codigoRuta = self.generarCodigoRuta()
        self.__class__.setContador(self.__class__.getContador()+1)
        
    def getCodigoRuta(self):
        return self.codigoRuta
    def getNombre(self):
        return self.__nombre
    def getTarifaMensual(self):
        return self.__tarifaMensual
    def getEstudiantes(self):
        return self.__estudiantes
    def getVehiculoAsignado(self):
        return self.__vehiculoAsignado
    def getConductorAsignado(self):
        return self.__conductorAsignado
        
    def setNombre(self, nombre):
        self.__nombre = nombre          
    def setTarifaMensual(self, tarifaMensual):
        self.__tarifaMensual = tarifaMensual
    def setVehiculoAsignado(self, vehiculo):
        self.__vehiculoAsignado = vehiculo
    def setConductorAsignado(self, conductor):
        self.__conductorAsignado = conductor

    nombre = property(getNombre, setNombre)
    tarifaMensual = property(getTarifaMensual, setTarifaMensual)
    estudiantes = property(getEstudiantes)
    vehiculoAsignado = property(getVehiculoAsignado, setVehiculoAsignado)
    conductorAsignado = property(getConductorAsignado, setConductorAsignado)
    
    @classmethod
    def getContador(cls):
        return cls._contador
    @classmethod
    def setContador(cls, valor):
        cls._contador = valor
        
    def generarCodigoRuta(self):
        contador = self.__class__.getContador()
        if contador < 10:
            return f"R00{contador}"
        elif contador < 100:
            return f"R0{contador}"
        elif contador < 1000:
            return f"R{contador}"
        else:
            return "ERROR: MAX"
    
    def agregarEstudiante(self, estudiante):
        if estudiante not in self.__estudiantes:
            self.__estudiantes.append(estudiante)
            estudiante.rutaAsignada = self
            
    def getNumeroEstudiantes(self):
        return len(self.__estudiantes)
    
    def calcularIngresoMensual(self):
        return self.getNumeroEstudiantes() * self.__tarifaMensual
    
    def registro(self):
        print("\n=== REGISTRO DE RUTA ===")
        nombre = validaCadena(3, 50, "Ingrese nombre de la ruta: ")
        tarifaMensual = validaFlotante(50, 1000, "Ingrese tarifa mensual (S/.): ")
        
        self.__init__(nombre, tarifaMensual)
        mensaje("exito", f"Ruta {nombre} registrada con código {self.codigoRuta}")
    
    def eliminar(self):
        print(f"\n=== ELIMINAR RUTA ===")
        print(f"Ruta: {self.nombre}")
        print(f"Código: {self.codigoRuta}")
        print(f"Estudiantes asignados: {self.getNumeroEstudiantes()}")
        if self.getNumeroEstudiantes() > 0:
            mensaje("advertencia", "Esta ruta tiene estudiantes asignados")
        confirmacion = validaSiNo("¿Está seguro de eliminar esta ruta?")
        if confirmacion:
            mensaje("exito", f"Ruta {self.codigoRuta} eliminada correctamente")
            return True
        else:
            mensaje("advertencia", "Operación cancelada")
            return False
    
    def actualizar(self):
        print(f"\n=== ACTUALIZAR RUTA ===")
        print(f"Ruta actual: {self.nombre}")
        
        opciones = ["Nombre", "Tarifa Mensual", "Salir"]
        while True:
            opcion = validaOpcion(opciones, "\n¿Qué desea actualizar?")
            
            if opcion == 1:
                nuevoNombre = validaCadena(3, 50, "Ingrese nuevo nombre: ")
                self.setNombre(nuevoNombre)
                mensaje("exito", "Nombre actualizado")
            elif opcion == 2:
                nuevaTarifa = validaFlotante(50, 1000, "Ingrese nueva tarifa (S/.): ")
                self.setTarifaMensual(nuevaTarifa)
                mensaje("exito", "Tarifa actualizada")
            elif opcion == 3:
                mensaje("exito", "Actualización completada")
                break
        
    def __str__(self):
        return f"Ruta: {self.codigoRuta} - {self.nombre}, Tarifa: S/.{self.tarifaMensual}, Estudiantes: {self.getNumeroEstudiantes()}"
    