from vehiculo import Vehiculo
from estudiante import Estudiante
from conductor import Conductor
from ruta import Ruta
from asistencia import Asistencia
from validacion import validaCadena, validaDNI, validaEdad, validaSiNo, validaEntero, validaPlaca, validaFlotante, validaOpcion, mensaje
import pandas as pd
from colorama import Fore, Back, Style, init

init(autoreset=True)

class Empresa:
    def __init__(self, nombre):
        self.__nombre = nombre
        self.__estudiantes = []
        self.__conductores = []
        self.__vehiculos = []
        self.__rutas = []
        self.__asistencias = []

    #getters
    def getNombre(self):
        return self.__nombre
    def getEstudiantes(self):
        return self.__estudiantes
    def getConductores(self):
        return self.__conductores
    def getVehiculos(self):
        return self.__vehiculos
    def getRutas(self):
        return self.__rutas
    def getAsistencias(self):
        return self.__asistencias

    #setters
    def setNombre(self, nombre):
        self.__nombre = nombre

    #properties
    nombre = property(getNombre, setNombre)
    estudiantes = property(getEstudiantes)
    conductores = property(getConductores)
    vehiculos = property(getVehiculos)
    rutas = property(getRutas)
    asistencias = property(getAsistencias)

    #MÉTODOS PARA ESTUDIANTES
    def registrarEstudiante(self):
        print("\n=== REGISTRO DE ESTUDIANTE ===")
        nombre = validaCadena(2, 50, "Ingrese nombre: ")
        apellidoPaterno = validaCadena(2, 50, "Ingrese apellido paterno: ")
        apellidoMaterno = validaCadena(2, 50, "Ingrese apellido materno: ")
        dni = validaDNI("Ingrese DNI (8 dígitos): ")
        edad = validaEdad("Ingrese edad: ")
        estadoPago = validaSiNo("¿El estudiante ha pagado?")
        
        estudiante = Estudiante(nombre, apellidoPaterno, apellidoMaterno, dni, edad, estadoPago)
        self.__estudiantes.append(estudiante)
        mensaje("exito", f"Estudiante {nombre} {apellidoPaterno} registrado con código {estudiante.codigoEstudiante}")
    
    def listarEstudiantes(self):
        if not self.__estudiantes:
            mensaje("advertencia", "No hay estudiantes registrados")
        else:
            print(f"\n{Back.GREEN}{Fore.BLACK}{'═'*80}{Style.RESET_ALL}")
            print(f"{Fore.GREEN}{Style.BRIGHT}   LISTA DE ESTUDIANTES{Style.RESET_ALL}")
            print(f"{Back.GREEN}{Fore.BLACK}{'═'*80}{Style.RESET_ALL}")
            datos = []
            for est in self.__estudiantes:
                ruta = est.rutaAsignada.codigoRuta if est.rutaAsignada else "Sin asignar"
                pago = "Al día" if est.estadoPago else "Pendiente"
                datos.append({
                    'Código': est.codigoEstudiante,
                    'Nombre': f"{est.getNombre()} {est.getApellidoPaterno()}",
                    'DNI': est.getDni(),
                    'Edad': est.getEdad(),
                    'Ruta': ruta,
                    'Estado Pago': pago
                })
            df = pd.DataFrame(datos)
            print(df.to_string(index=False))
            print(f"{Fore.GREEN}Total: {len(self.__estudiantes)} estudiantes{Style.RESET_ALL}")
    
    def listarEstudiantesCodigos(self):
        """Muestra una lista compacta de estudiantes con código y nombre"""
        if not self.__estudiantes:
            mensaje("advertencia", "No hay estudiantes registrados")
            return False
        print("\n--- Estudiantes Disponibles ---")
        for est in self.__estudiantes:
            print(f"{est.codigoEstudiante}: {est.getNombre()} {est.getApellidoPaterno()}")
        return True
    
    def buscarEstudiante(self, codigo):
        for est in self.__estudiantes:
            if est.codigoEstudiante == codigo:
                return est
        return None
    
    def eliminarEstudiante(self):
        codigo = validaCadena(4, 4, "Ingrese código del estudiante (Ej: E001): ").upper()
        estudiante = self.buscarEstudiante(codigo)
        if estudiante:
            if estudiante.eliminar():
                self.__estudiantes.remove(estudiante)
        else:
            mensaje("error", f"No se encontró estudiante con código {codigo}")
    
    def actualizarEstudiante(self):
        codigo = validaCadena(4, 4, "Ingrese código del estudiante (Ej: E001): ").upper()
        estudiante = self.buscarEstudiante(codigo)
        if estudiante:
            estudiante.actualizar()
        else:
            mensaje("error", f"No se encontró estudiante con código {codigo}")
    
    #MÉTODOS PARA CONDUCTORES
    def registrarConductor(self):
        print("\n=== REGISTRO DE CONDUCTOR ===")
        nombre = validaCadena(2, 50, "Ingrese nombre: ")
        apellidoPaterno = validaCadena(2, 50, "Ingrese apellido paterno: ")
        apellidoMaterno = validaCadena(2, 50, "Ingrese apellido materno: ")
        dni = validaDNI("Ingrese DNI (8 dígitos): ")
        edad = validaEdad("Ingrese edad: ")
        licenciaConducir = validaCadena(9, 9, "Ingrese licencia de conducir (9 caracteres): ")
        vigenciaLicencia = validaCadena(10, 10, "Ingrese vigencia (DD/MM/AAAA): ")
        
        conductor = Conductor(nombre, apellidoPaterno, apellidoMaterno, dni, edad, licenciaConducir, vigenciaLicencia)
        self.__conductores.append(conductor)
        mensaje("exito", f"Conductor {nombre} {apellidoPaterno} registrado con código {conductor.codigoConductor}")
    
    def listarConductores(self):
        if not self.__conductores:
            mensaje("advertencia", "No hay conductores registrados")
        else:
            print(f"\n{Back.YELLOW}{Fore.BLACK}{'═'*80}{Style.RESET_ALL}")
            print(f"{Fore.YELLOW}{Style.BRIGHT}   LISTA DE CONDUCTORES{Style.RESET_ALL}")
            print(f"{Back.YELLOW}{Fore.BLACK}{'═'*80}{Style.RESET_ALL}")
            datos = []
            for cond in self.__conductores:
                vehiculo = cond.vehiculoAsignado.codigoVehiculo if cond.vehiculoAsignado else "Sin asignar"
                datos.append({
                    'Código': cond.codigoConductor,
                    'Nombre': f"{cond.getNombre()} {cond.getApellidoPaterno()}",
                    'DNI': cond.getDni(),
                    'Edad': cond.getEdad(),
                    'Licencia': cond.licenciaConducir,
                    'Vigencia': cond.vigenciaLicencia,
                    'Vehículo': vehiculo,
                    'Recorridos': cond.recorridos
                })
            df = pd.DataFrame(datos)
            print(df.to_string(index=False))
            print(f"{Fore.YELLOW}Total: {len(self.__conductores)} conductores{Style.RESET_ALL}")
    
    def listarConductoresCodigos(self):
        """Muestra una lista compacta de conductores con código y nombre"""
        if not self.__conductores:
            mensaje("advertencia", "No hay conductores registrados")
            return False
        print("\n--- Conductores Disponibles ---")
        for cond in self.__conductores:
            print(f"{cond.codigoConductor}: {cond.getNombre()} {cond.getApellidoPaterno()}")
        return True
    
    def buscarConductor(self, codigo):
        for cond in self.__conductores:
            if cond.codigoConductor == codigo:
                return cond
        return None
    
    def eliminarConductor(self):
        codigo = validaCadena(4, 4, "Ingrese código del conductor (Ej: C001): ").upper()
        conductor = self.buscarConductor(codigo)
        if conductor:
            if conductor.eliminar():
                self.__conductores.remove(conductor)
        else:
            mensaje("error", f"No se encontró conductor con código {codigo}")
    
    def actualizarConductor(self):
        codigo = validaCadena(4, 4, "Ingrese código del conductor (Ej: C001): ").upper()
        conductor = self.buscarConductor(codigo)
        if conductor:
            conductor.actualizar()
        else:
            mensaje("error", f"No se encontró conductor con código {codigo}")

    
    #MÉTODOS PARA VEHÍCULOS
    def registrarVehiculo(self):
        print("\n=== REGISTRO DE VEHÍCULO ===")
        marca = validaCadena(2, 30, "Ingrese marca del vehículo: ")
        placa = validaPlaca("Ingrese placa del vehículo: ")
        capacidad = validaEntero(5, 60, "Ingrese capacidad del vehículo: ")
        
        vehiculo = Vehiculo(marca, placa, capacidad)
        self.__vehiculos.append(vehiculo)
        mensaje("exito", f"Vehículo {marca} registrado con código {vehiculo.codigoVehiculo}")
    
    def listarVehiculos(self):
        if not self.__vehiculos:
            mensaje("advertencia", "No hay vehículos registrados")
        else:
            print(f"\n{Back.MAGENTA}{Fore.WHITE}{'═'*80}{Style.RESET_ALL}")
            print(f"{Fore.MAGENTA}{Style.BRIGHT}   LISTA DE VEHÍCULOS{Style.RESET_ALL}")
            print(f"{Back.MAGENTA}{Fore.WHITE}{'═'*80}{Style.RESET_ALL}")
            datos = []
            for veh in self.__vehiculos:
                conductor = veh.conductorAsignado.codigoConductor if veh.conductorAsignado else "Sin asignar"
                ruta = veh.rutaAsignada.codigoRuta if veh.rutaAsignada else "Sin asignar"
                datos.append({
                    'Código': veh.codigoVehiculo,
                    'Marca': veh.marca,
                    'Placa': veh.placa,
                    'Capacidad': veh.capacidad,
                    'Conductor': conductor,
                    'Ruta': ruta
                })
            df = pd.DataFrame(datos)
            print(df.to_string(index=False))
            print(f"{Fore.MAGENTA}Total: {len(self.__vehiculos)} vehículos{Style.RESET_ALL}")
    
    def listarVehiculosCodigos(self):
        """Muestra una lista compacta de vehículos con código, marca y placa"""
        if not self.__vehiculos:
            mensaje("advertencia", "No hay vehículos registrados")
            return False
        print("\n--- Vehículos Disponibles ---")
        for veh in self.__vehiculos:
            print(f"{veh.codigoVehiculo}: {veh.marca} - {veh.placa}")
        return True
    
    def buscarVehiculo(self, codigo):
        for veh in self.__vehiculos:
            if veh.codigoVehiculo == codigo:
                return veh
        return None
    
    def eliminarVehiculo(self):
        codigo = validaCadena(4, 4, "Ingrese código del vehículo (Ej: V001): ").upper()
        vehiculo = self.buscarVehiculo(codigo)
        if vehiculo:
            if vehiculo.eliminar():
                self.__vehiculos.remove(vehiculo)
        else:
            mensaje("error", f"No se encontró vehículo con código {codigo}")
    
    def actualizarVehiculo(self):
        codigo = validaCadena(4, 4, "Ingrese código del vehículo (Ej: V001): ").upper()
        vehiculo = self.buscarVehiculo(codigo)
        if vehiculo:
            vehiculo.actualizar()
        else:
            mensaje("error", f"No se encontró vehículo con código {codigo}")
    
    #MÉTODOS PARA RUTAS
    def registrarRuta(self):
        print("\n=== REGISTRO DE RUTA ===")
        nombre = validaCadena(3, 50, "Ingrese nombre de la ruta: ")
        tarifaMensual = validaFlotante(50, 1000, "Ingrese tarifa mensual (S/.): ")
        
        ruta = Ruta(nombre, tarifaMensual)
        self.__rutas.append(ruta)
        mensaje("exito", f"Ruta {nombre} registrada con código {ruta.codigoRuta}")
    
    def listarRutas(self):
        if not self.__rutas:
            mensaje("advertencia", "No hay rutas registradas")
        else:
            print(f"\n{Back.CYAN}{Fore.BLACK}{'═'*80}{Style.RESET_ALL}")
            print(f"{Fore.CYAN}{Style.BRIGHT}   LISTA DE RUTAS{Style.RESET_ALL}")
            print(f"{Back.CYAN}{Fore.BLACK}{'═'*80}{Style.RESET_ALL}")
            datos = []
            for ruta in self.__rutas:
                vehiculo = ruta.vehiculoAsignado.codigoVehiculo if ruta.vehiculoAsignado else "Sin asignar"
                conductor = ruta.conductorAsignado.codigoConductor if ruta.conductorAsignado else "Sin asignar"
                datos.append({
                    'Código': ruta.codigoRuta,
                    'Nombre': ruta.nombre,
                    'Estudiantes': ruta.getNumeroEstudiantes(),
                    'Costo': f"S/. {ruta.tarifaMensual:.2f}",
                    'Ingreso': f"S/. {ruta.calcularIngresoMensual():.2f}",
                    'Vehículo': vehiculo,
                    'Conductor': conductor
                })
            df = pd.DataFrame(datos)
            print(df.to_string(index=False))
            print(f"{Fore.CYAN}Total: {len(self.__rutas)} rutas{Style.RESET_ALL}")
    
    def listarRutasCodigos(self):
        """Muestra una lista compacta de rutas con código y nombre"""
        if not self.__rutas:
            mensaje("advertencia", "No hay rutas registradas")
            return False
        print("\n--- Rutas Disponibles ---")
        for ruta in self.__rutas:
            print(f"{ruta.codigoRuta}: {ruta.nombre}")
        return True
    
    def buscarRuta(self, codigo):
        for ruta in self.__rutas:
            if ruta.codigoRuta == codigo:
                return ruta
        return None
    
    def asignarEstudianteRuta(self):
        if not self.listarEstudiantesCodigos():
            return
        codigoEst = validaCadena(4, 4, "Ingrese código del estudiante: ").upper()
        
        if not self.listarRutasCodigos():
            return
        codigoRuta = validaCadena(4, 4, "Ingrese código de la ruta: ").upper()
        
        estudiante = self.buscarEstudiante(codigoEst)
        ruta = self.buscarRuta(codigoRuta)
        
        if estudiante and ruta:
            ruta.agregarEstudiante(estudiante)
            mensaje("exito", f"Estudiante {codigoEst} asignado a ruta {codigoRuta}")
        else:
            mensaje("error", "Estudiante o ruta no encontrados")
    
    def asignarConductorVehiculo(self):
        if not self.listarConductoresCodigos():
            return
        codigoCond = validaCadena(4, 4, "Ingrese código del conductor: ").upper()
        
        if not self.listarVehiculosCodigos():
            return
        codigoVeh = validaCadena(4, 4, "Ingrese código del vehículo: ").upper()
        
        conductor = self.buscarConductor(codigoCond)
        vehiculo = self.buscarVehiculo(codigoVeh)
        
        if conductor and vehiculo:
            conductor.setVehiculoAsignado(vehiculo)
            vehiculo.setConductorAsignado(conductor)
            mensaje("exito", f"Conductor {codigoCond} asignado a vehículo {codigoVeh}")
        else:
            mensaje("error", "Conductor o vehículo no encontrados")
    
    def asignarVehiculoRuta(self):
        if not self.listarVehiculosCodigos():
            return
        codigoVeh = validaCadena(4, 4, "Ingrese código del vehículo: ").upper()
        
        if not self.listarRutasCodigos():
            return
        codigoRuta = validaCadena(4, 4, "Ingrese código de la ruta: ").upper()
        
        vehiculo = self.buscarVehiculo(codigoVeh)
        ruta = self.buscarRuta(codigoRuta)
        
        if vehiculo and ruta:
            ruta.setVehiculoAsignado(vehiculo)
            vehiculo.setRutaAsignada(ruta)
            mensaje("exito", f"Vehículo {codigoVeh} asignado a ruta {codigoRuta}")
        else:
            mensaje("error", "Vehículo o ruta no encontrados")
    
    def registrarAsistencia(self):
        from datetime import datetime
        
        if not self.listarEstudiantesCodigos():
            return
        codigoEst = validaCadena(4, 4, "Ingrese código del estudiante: ").upper()
        estudiante = self.buscarEstudiante(codigoEst)
        
        if estudiante and estudiante.rutaAsignada:
            fecha = datetime.now().strftime("%d/%m/%Y %H:%M")
            estado = "Presente" if validaSiNo("¿El estudiante está presente?") else "Ausente"
            
            asistencia = Asistencia(estudiante, estudiante.rutaAsignada, fecha, estado)
            self.__asistencias.append(asistencia)
            mensaje("exito", f"Asistencia registrada: {estado}")
        else:
            mensaje("error", "Estudiante no encontrado o sin ruta asignada")
    
    def listarAsistencias(self):
        if not self.__asistencias:
            mensaje("advertencia", "No hay asistencias registradas")
        else:
            print(f"\n{Back.BLUE}{Fore.WHITE}{'═'*80}{Style.RESET_ALL}")
            print(f"{Fore.BLUE}{Style.BRIGHT}   REGISTRO DE ASISTENCIAS{Style.RESET_ALL}")
            print(f"{Back.BLUE}{Fore.WHITE}{'═'*80}{Style.RESET_ALL}")
            datos = []
            for asist in self.__asistencias:
                datos.append({
                    'Estudiante': asist.estudiante.codigoEstudiante,
                    'Nombre': f"{asist.estudiante.getNombre()} {asist.estudiante.getApellidoPaterno()}",
                    'Ruta': asist.ruta.codigoRuta,
                    'Fecha': asist.fecha,
                    'Estado': asist.estado
                })
            df = pd.DataFrame(datos)
            print(df.to_string(index=False))
            print(f"{Fore.BLUE}Total: {len(self.__asistencias)} asistencias{Style.RESET_ALL}")
    
    def __str__(self):
        return f"""
{Back.CYAN}{Fore.BLACK}{'═'*50}{Style.RESET_ALL}
{Fore.CYAN}{Style.BRIGHT}   EMPRESA: {self.nombre}{Style.RESET_ALL}
{Back.CYAN}{Fore.BLACK}{'═'*50}{Style.RESET_ALL}
{Fore.GREEN}Estudiantes:{Style.RESET_ALL} {len(self.__estudiantes)}
{Fore.YELLOW}Conductores:{Style.RESET_ALL} {len(self.__conductores)}
{Fore.MAGENTA}Vehículos:{Style.RESET_ALL} {len(self.__vehiculos)}
{Fore.CYAN}Rutas:{Style.RESET_ALL} {len(self.__rutas)}
{Fore.BLUE}Asistencias:{Style.RESET_ALL} {len(self.__asistencias)}
{Back.CYAN}{Fore.BLACK}{'═'*50}{Style.RESET_ALL}
"""