class Persona:
    _contador = 0  
    def __init__(self, nombre, apellidoPaterno, apellidoMaterno, dni, edad):
        self.__nombre = nombre
        self.__apellidoPaterno = apellidoPaterno
        self.__apellidoMaterno = apellidoMaterno
        self.__dni = dni
        self.__edad = edad
        self.__codigo = None

    #getters
    def getNombre(self):
        return self.__nombre
    def getApellidoPaterno(self):
        return self.__apellidoPaterno
    def getApellidoMaterno(self):
        return self.__apellidoMaterno
    def getDni(self):
        return self.__dni
    def getEdad(self):
        return self.__edad
    def getCodigo(self):
        return self.__codigo
    
    #setters
    def setNombre(self, nombre):
        self.__nombre = nombre
    def setApellidoPaterno(self, apellidoPaterno):
        self.__apellidoPaterno = apellidoPaterno
    def setApellidoMaterno(self, apellidoMaterno):
        self.__apellidoMaterno = apellidoMaterno
    def setDni(self, dni):
        self.__dni = dni
    def setEdad(self, edad):
        self.__edad = edad
    def setCodigo(self,codigo):
        self.__codigo = codigo
    #class methods
    @classmethod
    def getContador(cls):
        return cls._contador
    @classmethod
    def setContador(cls,valor):
        cls._contador = valor

    #properties
    nombre = property(getNombre, setNombre)
    apellidoPaterno = property(getApellidoPaterno, setApellidoPaterno)
    apellidoMaterno = property(getApellidoMaterno, setApellidoMaterno)
    dni = property(getDni, setDni)
    edad = property(getEdad, setEdad)
    codigo = property(getCodigo,setCodigo)

    #methods
    def generaCodigo(self):
        pass
    def registro(self):
        pass
    def eliminar(self):
        pass    
    def actualizar(self):
        pass 
    def __str__(self):
        return f"Nombre completo: {self.apellidoPaterno} {self.apellidoMaterno} {self.nombre}, DNI: {self.dni}, Edad: {self.edad}"
