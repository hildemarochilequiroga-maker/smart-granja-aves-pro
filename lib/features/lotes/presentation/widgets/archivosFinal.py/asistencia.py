from datetime import datetime

class Asistencia:
    def __init__(self, estudiante, ruta, fecha, estado):
        self.__estudiante = estudiante
        self.__ruta = ruta
        self.__fecha = fecha
        self.__estado = estado
    
    def getEstudiante(self):
        return self.__estudiante
    
    def getRuta(self):
        return self.__ruta
    
    def getFecha(self):
        return self.__fecha
    
    def getEstado(self):
        return self.__estado
    
    def setEstado(self, estado):
        self.__estado = estado
    
    estudiante = property(getEstudiante)
    ruta = property(getRuta)
    fecha = property(getFecha)
    estado = property(getEstado, setEstado)
    
    def __str__(self):
        return f"Asistencia - Estudiante: {self.estudiante.codigoEstudiante}, Ruta: {self.ruta.codigoRuta}, Fecha: {self.fecha}, Estado: {self.estado}"
