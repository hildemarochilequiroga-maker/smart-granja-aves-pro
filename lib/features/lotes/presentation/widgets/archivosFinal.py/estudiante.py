from persona import Persona
from validacion import validaCadena, validaDNI, validaEdad, validaSiNo, validaOpcion, mensaje

class Estudiante(Persona):
    _contador = 0
    def __init__(self, nombre, apellidoPaterno, apellidoMaterno, dni, edad, estadoPago, rutaAsignada=None):
        super().__init__(nombre, apellidoPaterno, apellidoMaterno, dni, edad)
        self.__estadoPago = estadoPago
        self.__rutaAsignada = rutaAsignada
        self.codigoEstudiante = self.generaCodigo()
        self.__class__.setContador(self.__class__.getContador()+1)
        
    #getters   
    def getEstadoPago(self):
        return self.__estadoPago
    def getRutaAsignada(self):
        return self.__rutaAsignada
        
    #setters
    def setEstadoPago(self, estadoPago):
        self.__estadoPago = estadoPago
    def setRutaAsignada(self, rutaAsignada):
        self.__rutaAsignada = rutaAsignada

    #properties
    estadoPago = property(getEstadoPago, setEstadoPago)
    rutaAsignada = property(getRutaAsignada, setRutaAsignada)
    
    @classmethod
    def getContador(cls):
        return cls._contador
    @classmethod
    def setContador(cls,valor):
        cls._contador = valor

    #methods
    def generaCodigo(self):
        contador = self.__class__.getContador()
        if contador < 10:
            return f"E00{contador}"
        elif contador < 100:
            return f"E0{contador}"
        elif contador < 1000:
            return f"E{contador}"
        else:
            return "ERROR: MAX"
            
    def registro(self):
        print("\n=== REGISTRO DE ESTUDIANTE ===")
        nombre = validaCadena(2, 50, "Ingrese nombre: ")
        apellidoPaterno = validaCadena(2, 50, "Ingrese apellido paterno: ")
        apellidoMaterno = validaCadena(2, 50, "Ingrese apellido materno: ")
        dni = validaDNI("Ingrese DNI (8 dígitos): ")
        edad = validaEdad("Ingrese edad: ")
        estadoPago = validaSiNo("¿El estudiante ha pagado?")
        
        self.__init__(nombre, apellidoPaterno, apellidoMaterno, dni, edad, estadoPago)
        mensaje("exito", f"Estudiante {nombre} {apellidoPaterno} registrado correctamente con código {self.codigoEstudiante}")
        
    def eliminar(self):
        print(f"\n=== ELIMINAR ESTUDIANTE ===")
        print(f"Estudiante: {self.getNombre()} {self.getApellidoPaterno()}")
        print(f"Código: {self.codigoEstudiante}")
        confirmacion = validaSiNo("¿Está seguro de eliminar este estudiante?")
        if confirmacion:
            mensaje("exito", f"Estudiante {self.codigoEstudiante} eliminado correctamente")
            return True
        else:
            mensaje("advertencia", "Operación cancelada")
            return False
            
    def actualizar(self):
        print(f"\n=== ACTUALIZAR ESTUDIANTE ===")
        print(f"Estudiante actual: {self.getNombre()} {self.getApellidoPaterno()}")
        
        opciones = ["Nombre", "Apellido Paterno", "Apellido Materno", "Edad", "Estado de Pago", "Salir"]
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
                nuevoEstado = validaSiNo("¿Ha pagado el estudiante?")
                self.setEstadoPago(nuevoEstado)
                mensaje("exito", "Estado de pago actualizado")
            elif opcion == 6:
                mensaje("exito", "Actualización completada")
                break
    def __str__(self):
        rutaInfo = f"Ruta: {self.rutaAsignada.nombre}" if self.rutaAsignada else "Sin ruta"
        return f"ESTUDIANTE: ({self.codigoEstudiante}) {super().__str__()}, Estado de Pago: {self.estadoPago}, {rutaInfo}"