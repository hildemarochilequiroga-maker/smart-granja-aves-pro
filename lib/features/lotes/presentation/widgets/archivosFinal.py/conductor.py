from persona import Persona
from validacion import validaCadena, validaDNI, validaEdad, validaSiNo, validaOpcion, mensaje

class Conductor(Persona):
    _contador = 0
    def __init__(self, nombre, apellidoPaterno, apellidoMaterno, dni, edad, licenciaConducir, vigenciaLicencia):
            super().__init__(nombre, apellidoPaterno, apellidoMaterno, dni, edad)
            self.__licenciaConducir = licenciaConducir
            self.__vigenciaLicencia = vigenciaLicencia
            self.__vehiculoAsignado = None
            self.codigoConductor = self.generaCodigo()
            self.__class__.setContador(self.__class__.getContador()+1)
            self.__recorridos = 0

    #getters
    def getLicenciaConducir(self):
        return self.__licenciaConducir
    def getVigenciaLicencia(self):
        return self.__vigenciaLicencia
    def getVehiculoAsignado(self):
        return self.__vehiculoAsignado
    def getRecorridos(self):
        return self.__recorridos
    
    #setters
    def setLicenciaConducir(self, licenciaConducir):
        self.__licenciaConducir = licenciaConducir
    def setVigenciaLicencia(self, vigenciaLicencia):
        self.__vigenciaLicencia = vigenciaLicencia
    def setVehiculoAsignado(self, vehiculoAsignado):
        self.__vehiculoAsignado = vehiculoAsignado
    def setRecorridos(self, recorridos):
        self.__recorridos = recorridos

    #properties
    licenciaConducir = property(getLicenciaConducir, setLicenciaConducir)
    vigenciaLicencia = property(getVigenciaLicencia, setVigenciaLicencia)
    vehiculoAsignado = property(getVehiculoAsignado, setVehiculoAsignado)
    recorridos = property(getRecorridos, setRecorridos)

    @classmethod
    def getContador(cls):
        return cls._contador
    @classmethod
    def setContador(cls,valor):
        cls._contador = valor
    
    def generaCodigo(self):
        contador = self.__class__.getContador()
        if contador < 10:
            return f"C00{contador}"
        elif contador < 100:
            return f"C0{contador}"
        elif contador < 1000:
            return f"C{contador}"
        else:
            return "ERROR: MAX"
    
    def incrementarRecorridos(self):
        self.__recorridos += 1
    
    def registro(self):
        print("\n=== REGISTRO DE CONDUCTOR ===")
        nombre = validaCadena(2, 50, "Ingrese nombre: ")
        apellidoPaterno = validaCadena(2, 50, "Ingrese apellido paterno: ")
        apellidoMaterno = validaCadena(2, 50, "Ingrese apellido materno: ")
        dni = validaDNI("Ingrese DNI (8 dígitos): ")
        edad = validaEdad("Ingrese edad: ")
        licenciaConducir = validaCadena(9, 9, "Ingrese licencia de conducir (9 caracteres): ")
        vigenciaLicencia = validaCadena(10, 10, "Ingrese vigencia (DD/MM/AAAA): ")
        
        self.__init__(nombre, apellidoPaterno, apellidoMaterno, dni, edad, licenciaConducir, vigenciaLicencia)
        mensaje("exito", f"Conductor {nombre} {apellidoPaterno} registrado correctamente con código {self.codigoConductor}")
    
    def eliminar(self):
        print(f"\n=== ELIMINAR CONDUCTOR ===")
        print(f"Conductor: {self.getNombre()} {self.getApellidoPaterno()}")
        print(f"Código: {self.codigoConductor}")
        if self.vehiculoAsignado:
            mensaje("advertencia", f"Este conductor tiene asignado el vehículo {self.vehiculoAsignado.placa}")
        confirmacion = validaSiNo("¿Está seguro de eliminar este conductor?")
        if confirmacion:
            mensaje("exito", f"Conductor {self.codigoConductor} eliminado correctamente")
            return True
        else:
            mensaje("advertencia", "Operación cancelada")
            return False
    
    def actualizar(self):
        print(f"\n=== ACTUALIZAR CONDUCTOR ===")
        print(f"Conductor actual: {self.getNombre()} {self.getApellidoPaterno()}")
        
        opciones = ["Nombre", "Apellido Paterno", "Apellido Materno", "Edad", "Licencia de Conducir", "Vigencia de Licencia", "Salir"]
        while True:
            opcion = validaOpcion(opciones, "\n¿Qué desea actualizar?")
            
            if opcion == 1:
                nuevoNombre = validaCadena(2, 50, "Ingrese nuevo nombre: ")
                self.setNombre(nuevoNombre)
                mensaje("exito", "Nombre actualizado")
            elif opcion == 2:
                nuevoApellido = validaCadena(2, 50, "Ingrese nuevo apellido paterno: ")
                self.setApellidoPaterno(nuevoApellido)
                mensaje("exito", "Apellido paterno actualizado")
            elif opcion == 3:
                nuevoApellido = validaCadena(2, 50, "Ingrese nuevo apellido materno: ")
                self.setApellidoMaterno(nuevoApellido)
                mensaje("exito", "Apellido materno actualizado")
            elif opcion == 4:
                nuevaEdad = validaEdad("Ingrese nueva edad: ")
                self.setEdad(nuevaEdad)
                mensaje("exito", "Edad actualizada")
            elif opcion == 5:
                nuevaLicencia = validaCadena(9, 9, "Ingrese nueva licencia de conducir (9 caracteres): ")
                self.setLicenciaConducir(nuevaLicencia)
                mensaje("exito", "Licencia actualizada")
            elif opcion == 6:
                nuevaVigencia = validaCadena(10, 10, "Ingrese nueva vigencia (DD/MM/AAAA): ")
                self.setVigenciaLicencia(nuevaVigencia)
                mensaje("exito", "Vigencia actualizada")
            elif opcion == 7:
                mensaje("exito", "Actualización completada")
                break
    
    def __str__(self):
        vehiculoInfo = f"Placa: {self.vehiculoAsignado.placa}" if self.vehiculoAsignado else "Sin asignar"
        return f"CONDUCTOR: ({self.codigoConductor}) {super().__str__()}, Licencia: {self.licenciaConducir}, Vigencia: {self.vigenciaLicencia}, Vehículo: {vehiculoInfo}, Recorridos: {self.recorridos}"