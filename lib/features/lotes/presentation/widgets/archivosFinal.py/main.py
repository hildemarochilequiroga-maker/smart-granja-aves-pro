from empresa import Empresa
from estudiante import Estudiante
from conductor import Conductor
from vehiculo import Vehiculo
from ruta import Ruta
from asistencia import Asistencia
from validacion import validaOpcion, mensaje, validaCadena
from datetime import datetime, timedelta
from colorama import Fore, Back, Style, init
from graficasTransporte import datosTransporte
import os

# Inicializar colorama
init(autoreset=True)

def limpiarPantalla():
    """Limpia la pantalla de la consola"""
    os.system('cls' if os.name == 'nt' else 'clear')

def pausar():
    """Pausa la ejecución hasta que el usuario presione ENTER"""
    input(f"\n{Fore.CYAN}Presione ENTER para continuar...{Style.RESET_ALL}")

# ============================================
# PRECARGA DE DATOS - OBJETOS INICIALIZADOS
# ============================================

# Crear estudiantes
estudiante1 = Estudiante("Juan", "Pérez", "García", "12345678", 15, True)
estudiante2 = Estudiante("María", "López", "Martínez", "23456789", 14, True)
estudiante3 = Estudiante("Carlos", "Rodríguez", "Sánchez", "34567890", 16, False)
estudiante4 = Estudiante("Ana", "Fernández", "Torres", "45678901", 15, True)
estudiante5 = Estudiante("Luis", "González", "Ramírez", "56789012", 14, True)
estudiante6 = Estudiante("Sofia", "Díaz", "Cruz", "67890123", 15, False)
estudiante7 = Estudiante("Pedro", "Vargas", "Flores", "78901234", 16, True)
estudiante8 = Estudiante("Laura", "Castro", "Mendoza", "89012345", 14, True)
estudiante9 = Estudiante("Miguel", "Ramos", "Silva", "90123456", 15, True)
estudiante10 = Estudiante("Carmen", "Ortiz", "Reyes", "01234567", 16, False)

# Crear conductores
conductor1 = Conductor("Roberto", "Mendoza", "Lima", "11111111", 35, "L12345678", "15/12/2025")
conductor2 = Conductor("Patricia", "Silva", "Campos", "22222222", 40, "L23456789", "20/11/2025")
conductor3 = Conductor("Jorge", "Herrera", "Vega", "33333333", 38, "L34567890", "10/03/2026")
conductor4 = Conductor("Rosa", "Morales", "Pérez", "44444444", 42, "L45678901", "25/06/2026")
conductor5 = Conductor("Alberto", "Quispe", "Rojas", "55555555", 36, "L56789012", "30/09/2026")

# Crear vehículos
vehiculo1 = Vehiculo("Toyota", "ABC123", 25)
vehiculo2 = Vehiculo("Hyundai", "DEF456", 30)
vehiculo3 = Vehiculo("Nissan", "GHI789", 28)
vehiculo4 = Vehiculo("Kia", "JKL012", 32)
vehiculo5 = Vehiculo("Chevrolet", "MNO345", 26)

# Crear rutas
ruta1 = Ruta("Ruta Norte - Los Olivos", 150.00)
ruta2 = Ruta("Ruta Sur - Villa El Salvador", 180.00)
ruta3 = Ruta("Ruta Este - San Juan de Lurigancho", 160.00)
ruta4 = Ruta("Ruta Centro - Lima Cercado", 140.00)
ruta5 = Ruta("Ruta Oeste - Callao", 170.00)

# Asignar conductores a vehículos
conductor1.setVehiculoAsignado(vehiculo1)
vehiculo1.setConductorAsignado(conductor1)

conductor2.setVehiculoAsignado(vehiculo2)
vehiculo2.setConductorAsignado(conductor2)

conductor3.setVehiculoAsignado(vehiculo3)
vehiculo3.setConductorAsignado(conductor3)

conductor4.setVehiculoAsignado(vehiculo4)
vehiculo4.setConductorAsignado(conductor4)

conductor5.setVehiculoAsignado(vehiculo5)
vehiculo5.setConductorAsignado(conductor5)

# Asignar vehículos a rutas
vehiculo1.setRutaAsignada(ruta1)
ruta1.setVehiculoAsignado(vehiculo1)
ruta1.setConductorAsignado(conductor1)

vehiculo2.setRutaAsignada(ruta2)
ruta2.setVehiculoAsignado(vehiculo2)
ruta2.setConductorAsignado(conductor2)

vehiculo3.setRutaAsignada(ruta3)
ruta3.setVehiculoAsignado(vehiculo3)
ruta3.setConductorAsignado(conductor3)

vehiculo4.setRutaAsignada(ruta4)
ruta4.setVehiculoAsignado(vehiculo4)
ruta4.setConductorAsignado(conductor4)

vehiculo5.setRutaAsignada(ruta5)
ruta5.setVehiculoAsignado(vehiculo5)
ruta5.setConductorAsignado(conductor5)

# Asignar estudiantes a rutas
ruta1.agregarEstudiante(estudiante1)
ruta1.agregarEstudiante(estudiante2)

ruta2.agregarEstudiante(estudiante3)
ruta2.agregarEstudiante(estudiante4)

ruta3.agregarEstudiante(estudiante5)
ruta3.agregarEstudiante(estudiante6)

ruta4.agregarEstudiante(estudiante7)
ruta4.agregarEstudiante(estudiante8)

ruta5.agregarEstudiante(estudiante9)
ruta5.agregarEstudiante(estudiante10)

# Incrementar recorridos de conductores
conductor1.setRecorridos(15)
conductor2.setRecorridos(20)
conductor3.setRecorridos(25)
conductor4.setRecorridos(18)
conductor5.setRecorridos(22)

# Crear asistencias de prueba
fecha1 = (datetime.now() - timedelta(days=0)).strftime("%d/%m/%Y")
fecha2 = (datetime.now() - timedelta(days=1)).strftime("%d/%m/%Y")
fecha3 = (datetime.now() - timedelta(days=2)).strftime("%d/%m/%Y")
fecha4 = (datetime.now() - timedelta(days=3)).strftime("%d/%m/%Y")
fecha5 = (datetime.now() - timedelta(days=4)).strftime("%d/%m/%Y")

asistencia1 = Asistencia(estudiante1, ruta1, fecha1, "Presente")
asistencia2 = Asistencia(estudiante2, ruta1, fecha1, "Presente")
asistencia3 = Asistencia(estudiante3, ruta2, fecha1, "Ausente")
asistencia4 = Asistencia(estudiante4, ruta2, fecha1, "Presente")
asistencia5 = Asistencia(estudiante5, ruta3, fecha1, "Presente")
asistencia6 = Asistencia(estudiante6, ruta3, fecha1, "Presente")
asistencia7 = Asistencia(estudiante7, ruta4, fecha1, "Presente")

asistencia8 = Asistencia(estudiante1, ruta1, fecha2, "Presente")
asistencia9 = Asistencia(estudiante2, ruta1, fecha2, "Ausente")
asistencia10 = Asistencia(estudiante3, ruta2, fecha2, "Presente")
asistencia11 = Asistencia(estudiante4, ruta2, fecha2, "Presente")
asistencia12 = Asistencia(estudiante5, ruta3, fecha2, "Presente")

asistencia13 = Asistencia(estudiante1, ruta1, fecha3, "Presente")
asistencia14 = Asistencia(estudiante2, ruta1, fecha3, "Presente")
asistencia15 = Asistencia(estudiante3, ruta2, fecha3, "Presente")
asistencia16 = Asistencia(estudiante4, ruta2, fecha3, "Presente")

asistencia17 = Asistencia(estudiante1, ruta1, fecha4, "Presente")
asistencia18 = Asistencia(estudiante2, ruta1, fecha4, "Presente")
asistencia19 = Asistencia(estudiante5, ruta3, fecha4, "Presente")

asistencia20 = Asistencia(estudiante1, ruta1, fecha5, "Ausente")
asistencia21 = Asistencia(estudiante3, ruta2, fecha5, "Presente")

# ============================================
# FUNCIONES DEL SISTEMA
# ============================================

def mostrarBanner():
    print(f"\n{Back.CYAN}{Fore.BLACK}{'═'*60}{Style.RESET_ALL}")
    print(f"{Fore.CYAN}{Style.BRIGHT}    SISTEMA DE GESTIÓN DE TRANSPORTE ESCOLAR{Style.RESET_ALL}")
    print(f"{Back.CYAN}{Fore.BLACK}{'═'*60}{Style.RESET_ALL}")

def menuPrincipal():
    opciones = [
        "Gestión de Estudiantes",
        "Gestión de Conductores",
        "Gestión de Vehículos",
        "Gestión de Rutas",
        "Asignaciones",
        "Control de Asistencia",
        "Reportes",
        "Gráficos Estadísticos",
        "Información de la Empresa",
        "Salir"
    ]
    print(f"\n{Back.BLUE}{Fore.WHITE}{'═'*40}{Style.RESET_ALL}")
    print(f"{Fore.BLUE}{Style.BRIGHT}       MENÚ PRINCIPAL{Style.RESET_ALL}")
    print(f"{Back.BLUE}{Fore.WHITE}{'═'*40}{Style.RESET_ALL}")
    return validaOpcion(opciones, "")

def menuEstudiantes():
    opciones = [
        "Registrar Estudiante",
        "Listar Estudiantes",
        "Actualizar Estudiante",
        "Eliminar Estudiante",
        "Buscar Estudiante",
        "Volver al Menú Principal"
    ]
    print(f"\n{Back.GREEN}{Fore.BLACK}{'═'*40}{Style.RESET_ALL}")
    print(f"{Fore.GREEN}{Style.BRIGHT}   GESTIÓN DE ESTUDIANTES{Style.RESET_ALL}")
    print(f"{Back.GREEN}{Fore.BLACK}{'═'*40}{Style.RESET_ALL}")
    return validaOpcion(opciones, "")

def menuConductores():
    opciones = [
        "Registrar Conductor",
        "Listar Conductores",
        "Actualizar Conductor",
        "Eliminar Conductor",
        "Buscar Conductor",
        "Volver al Menú Principal"
    ]
    print(f"\n{Back.YELLOW}{Fore.BLACK}{'═'*40}{Style.RESET_ALL}")
    print(f"{Fore.YELLOW}{Style.BRIGHT}   GESTIÓN DE CONDUCTORES{Style.RESET_ALL}")
    print(f"{Back.YELLOW}{Fore.BLACK}{'═'*40}{Style.RESET_ALL}")
    return validaOpcion(opciones, "")

def menuVehiculos():
    opciones = [
        "Registrar Vehículo",
        "Listar Vehículos",
        "Actualizar Vehículo",
        "Eliminar Vehículo",
        "Buscar Vehículo",
        "Volver al Menú Principal"
    ]
    print(f"\n{Back.MAGENTA}{Fore.WHITE}{'═'*40}{Style.RESET_ALL}")
    print(f"{Fore.MAGENTA}{Style.BRIGHT}   GESTIÓN DE VEHÍCULOS{Style.RESET_ALL}")
    print(f"{Back.MAGENTA}{Fore.WHITE}{'═'*40}{Style.RESET_ALL}")
    return validaOpcion(opciones, "")

def menuRutas():
    opciones = [
        "Registrar Ruta",
        "Listar Rutas",
        "Actualizar Ruta",
        "Eliminar Ruta",
        "Buscar Ruta",
        "Ver Estudiantes por Ruta",
        "Volver al Menú Principal"
    ]
    print(f"\n{Back.CYAN}{Fore.BLACK}{'═'*40}{Style.RESET_ALL}")
    print(f"{Fore.CYAN}{Style.BRIGHT}   GESTIÓN DE RUTAS{Style.RESET_ALL}")
    print(f"{Back.CYAN}{Fore.BLACK}{'═'*40}{Style.RESET_ALL}")
    return validaOpcion(opciones, "")

def menuAsignaciones():
    opciones = [
        "Asignar Estudiante a Ruta",
        "Asignar Conductor a Vehículo",
        "Asignar Vehículo a Ruta",
        "Ver Todas las Asignaciones",
        "Volver al Menú Principal"
    ]
    print(f"\n{Back.WHITE}{Fore.BLACK}{'═'*40}{Style.RESET_ALL}")
    print(f"{Fore.WHITE}{Style.BRIGHT}   ASIGNACIONES{Style.RESET_ALL}")
    print(f"{Back.WHITE}{Fore.BLACK}{'═'*40}{Style.RESET_ALL}")
    return validaOpcion(opciones, "")

def menuAsistencia():
    opciones = [
        "Registrar Asistencia",
        "Ver Todas las Asistencias",
        "Ver Asistencia por Estudiante",
        "Ver Asistencia por Ruta",
        "Ver Asistencia por Fecha",
        "Volver al Menú Principal"
    ]
    print(f"\n{Back.BLUE}{Fore.WHITE}{'═'*40}{Style.RESET_ALL}")
    print(f"{Fore.BLUE}{Style.BRIGHT}   CONTROL DE ASISTENCIA{Style.RESET_ALL}")
    print(f"{Back.BLUE}{Fore.WHITE}{'═'*40}{Style.RESET_ALL}")
    return validaOpcion(opciones, "")

def menuReportes():
    opciones = [
        "Rutas Más Utilizadas",
        "Estudiantes con Mayor Asistencia",
        "Vehículos Más Usados",
        "Conductores con Más Recorridos",
        "Ingresos por Ruta",
        "Estudiantes con Pagos Pendientes",
        "Conductores con Licencia Próxima a Vencer",
        "Reporte General del Sistema",
        "Volver al Menú Principal"
    ]
    print(f"\n{Back.YELLOW}{Fore.BLACK}{'═'*40}{Style.RESET_ALL}")
    print(f"{Fore.YELLOW}{Style.BRIGHT}   REPORTES{Style.RESET_ALL}")
    print(f"{Back.YELLOW}{Fore.BLACK}{'═'*40}{Style.RESET_ALL}")
    return validaOpcion(opciones, "")

def menuAnalisisPandas():
    opciones = [
        "Operaciones Básicas con DataFrames",
        "Filtros Avanzados", 
        "Agrupaciones y Estadísticas",
        "Manipulación de Datos",
        "Uniones de DataFrames",
        "Visualizaciones Gráficas",
        "Dashboard Interactivo",
        "Reporte Completo de Estudiantes",
        "Reporte Financiero",
        "Exportar Reportes a Excel",
        "Volver al Menú Principal"
    ]
    print(f"\n{Back.MAGENTA}{Fore.WHITE}{'═'*40}{Style.RESET_ALL}")
    print(f"{Fore.MAGENTA}{Style.BRIGHT}   ANÁLISIS CON PANDAS{Style.RESET_ALL}")
    print(f"{Back.MAGENTA}{Fore.WHITE}{'═'*40}{Style.RESET_ALL}")
    return validaOpcion(opciones, "")

# FUNCIONES DE GESTIÓN DE ESTUDIANTES
def gestionarEstudiantes(empresa):
    while True:
        limpiarPantalla()
        opcion = menuEstudiantes()
        
        if opcion == 1:
            empresa.registrarEstudiante()
        elif opcion == 2:
            empresa.listarEstudiantes()
            pausar()
        elif opcion == 3:
            if empresa.listarEstudiantesCodigos():
                empresa.actualizarEstudiante()
        elif opcion == 4:
            if empresa.listarEstudiantesCodigos():
                empresa.eliminarEstudiante()
        elif opcion == 5:
            if empresa.listarEstudiantesCodigos():
                codigo = validaCadena(4, 4, "Ingrese código del estudiante: ").upper()
                estudiante = empresa.buscarEstudiante(codigo)
                if estudiante:
                    print(estudiante)
                    pausar()
                else:
                    mensaje("error", f"No se encontró estudiante con código {codigo}")
                    pausar()
        elif opcion == 6:
            break

# FUNCIONES DE GESTIÓN DE CONDUCTORES
def gestionarConductores(empresa):
    while True:
        limpiarPantalla()
        opcion = menuConductores()
        
        if opcion == 1:
            empresa.registrarConductor()
        elif opcion == 2:
            empresa.listarConductores()
            pausar()
        elif opcion == 3:
            if empresa.listarConductoresCodigos():
                empresa.actualizarConductor()
        elif opcion == 4:
            if empresa.listarConductoresCodigos():
                empresa.eliminarConductor()
        elif opcion == 5:
            if empresa.listarConductoresCodigos():
                codigo = validaCadena(4, 4, "Ingrese código del conductor: ").upper()
                conductor = empresa.buscarConductor(codigo)
                if conductor:
                    print(conductor)
                    pausar()
                else:
                    mensaje("error", f"No se encontró conductor con código {codigo}")
                    pausar()
        elif opcion == 6:
            break

# FUNCIONES DE GESTIÓN DE VEHÍCULOS
def gestionarVehiculos(empresa):
    while True:
        limpiarPantalla()
        opcion = menuVehiculos()
        
        if opcion == 1:
            empresa.registrarVehiculo()
        elif opcion == 2:
            empresa.listarVehiculos()
            pausar()
        elif opcion == 3:
            if empresa.listarVehiculosCodigos():
                empresa.actualizarVehiculo()
        elif opcion == 4:
            if empresa.listarVehiculosCodigos():
                empresa.eliminarVehiculo()
        elif opcion == 5:
            if empresa.listarVehiculosCodigos():
                codigo = validaCadena(4, 4, "Ingrese código del vehículo: ").upper()
                vehiculo = empresa.buscarVehiculo(codigo)
                if vehiculo:
                    print(vehiculo)
                    pausar()
                else:
                    mensaje("error", f"No se encontró vehículo con código {codigo}")
                    pausar()
        elif opcion == 6:
            break

# FUNCIONES DE GESTIÓN DE RUTAS
def gestionarRutas(empresa):
    while True:
        limpiarPantalla()
        opcion = menuRutas()
        
        if opcion == 1:
            empresa.registrarRuta()
        elif opcion == 2:
            empresa.listarRutas()
            pausar()
        elif opcion == 3:
            if empresa.listarRutasCodigos():
                codigo = validaCadena(4, 4, "Ingrese código de la ruta: ").upper()
                ruta = empresa.buscarRuta(codigo)
                if ruta:
                    ruta.actualizar()
                else:
                    mensaje("error", f"No se encontró ruta con código {codigo}")
        elif opcion == 4:
            if empresa.listarRutasCodigos():
                codigo = validaCadena(4, 4, "Ingrese código de la ruta: ").upper()
                ruta = empresa.buscarRuta(codigo)
                if ruta and ruta.eliminar():
                    empresa.getRutas().remove(ruta)
        elif opcion == 5:
            if empresa.listarRutasCodigos():
                codigo = validaCadena(4, 4, "Ingrese código de la ruta: ").upper()
                ruta = empresa.buscarRuta(codigo)
                if ruta:
                    print(ruta)
                    pausar()
                else:
                    mensaje("error", f"No se encontró ruta con código {codigo}")
                    pausar()
        elif opcion == 6:
            if empresa.listarRutasCodigos():
                codigo = validaCadena(4, 4, "Ingrese código de la ruta: ").upper()
                ruta = empresa.buscarRuta(codigo)
                if ruta:
                    print(f"\n{Back.GREEN}{Fore.BLACK}{'═'*50}{Style.RESET_ALL}")
                    print(f"{Fore.GREEN}{Style.BRIGHT}   ESTUDIANTES EN RUTA {ruta.codigoRuta}{Style.RESET_ALL}")
                    print(f"{Back.GREEN}{Fore.BLACK}{'═'*50}{Style.RESET_ALL}")
                    if ruta.getNumeroEstudiantes() == 0:
                        mensaje("advertencia", "No hay estudiantes asignados a esta ruta")
                    else:
                        for est in ruta.estudiantes:
                            print(f"{Fore.CYAN}-{Style.RESET_ALL} {Fore.WHITE}{est.codigoEstudiante}: {est.getNombre()} {est.getApellidoPaterno()}{Style.RESET_ALL}")
                    pausar()
                else:
                    mensaje("error", "Ruta no encontrada")
                    pausar()
        elif opcion == 7:
            break

# FUNCIONES DE ASIGNACIONES
def gestionarAsignaciones(empresa):
    while True:
        limpiarPantalla()
        opcion = menuAsignaciones()
        
        if opcion == 1:
            empresa.asignarEstudianteRuta()
        elif opcion == 2:
            empresa.asignarConductorVehiculo()
        elif opcion == 3:
            empresa.asignarVehiculoRuta()
        elif opcion == 4:
            print(f"\n{Back.BLUE}{Fore.WHITE}{'═'*50}{Style.RESET_ALL}")
            print(f"{Fore.BLUE}{Style.BRIGHT}   RESUMEN DE ASIGNACIONES{Style.RESET_ALL}")
            print(f"{Back.BLUE}{Fore.WHITE}{'═'*50}{Style.RESET_ALL}")
            
            print(f"\n{Fore.YELLOW}{Style.BRIGHT}--- Conductores y Vehículos ---{Style.RESET_ALL}")
            for conductor in empresa.getConductores():
                if conductor.vehiculoAsignado:
                    print(f"{Fore.CYAN}{conductor.codigoConductor}{Style.RESET_ALL} {Fore.WHITE}->{Style.RESET_ALL} {Fore.MAGENTA}Vehículo {conductor.vehiculoAsignado.codigoVehiculo}{Style.RESET_ALL}")
            
            print(f"\n{Fore.YELLOW}{Style.BRIGHT}--- Vehículos y Rutas ---{Style.RESET_ALL}")
            for vehiculo in empresa.getVehiculos():
                if vehiculo.rutaAsignada:
                    print(f"{Fore.MAGENTA}{vehiculo.codigoVehiculo}{Style.RESET_ALL} {Fore.WHITE}->{Style.RESET_ALL} {Fore.GREEN}Ruta {vehiculo.rutaAsignada.codigoRuta}{Style.RESET_ALL}")
            
            print(f"\n{Fore.YELLOW}{Style.BRIGHT}--- Estudiantes y Rutas ---{Style.RESET_ALL}")
            for estudiante in empresa.getEstudiantes():
                if estudiante.rutaAsignada:
                    print(f"{Fore.BLUE}{estudiante.codigoEstudiante}{Style.RESET_ALL} {Fore.WHITE}->{Style.RESET_ALL} {Fore.GREEN}Ruta {estudiante.rutaAsignada.codigoRuta}{Style.RESET_ALL}")
            pausar()
        elif opcion == 5:
            break

# FUNCIONES DE ASISTENCIA
def gestionarAsistencia(empresa):
    while True:
        limpiarPantalla()
        opcion = menuAsistencia()
        
        if opcion == 1:
            empresa.registrarAsistencia()
        elif opcion == 2:
            empresa.listarAsistencias()
            pausar()
        elif opcion == 3:
            if empresa.listarEstudiantesCodigos():
                codigo = validaCadena(4, 4, "Ingrese código del estudiante: ").upper()
                estudiante = empresa.buscarEstudiante(codigo)
                if estudiante:
                    print(f"\n{Back.GREEN}{Fore.BLACK}{'═'*50}{Style.RESET_ALL}")
                    print(f"{Fore.GREEN}{Style.BRIGHT}   ASISTENCIAS DE {estudiante.codigoEstudiante}{Style.RESET_ALL}")
                    print(f"{Back.GREEN}{Fore.BLACK}{'═'*50}{Style.RESET_ALL}")
                    encontradas = False
                    for asist in empresa.getAsistencias():
                        if asist.estudiante.codigoEstudiante == codigo:
                            print(asist)
                            encontradas = True
                    if not encontradas:
                        mensaje("advertencia", "No hay asistencias registradas para este estudiante")
                    pausar()
                else:
                    mensaje("error", "Estudiante no encontrado")
                    pausar()
        elif opcion == 4:
            if empresa.listarRutasCodigos():
                codigo = validaCadena(4, 4, "Ingrese código de la ruta: ").upper()
                ruta = empresa.buscarRuta(codigo)
                if ruta:
                    print(f"\n{Back.CYAN}{Fore.BLACK}{'═'*50}{Style.RESET_ALL}")
                    print(f"{Fore.CYAN}{Style.BRIGHT}   ASISTENCIAS DE RUTA {ruta.codigoRuta}{Style.RESET_ALL}")
                    print(f"{Back.CYAN}{Fore.BLACK}{'═'*50}{Style.RESET_ALL}")
                    encontradas = False
                    for asist in empresa.getAsistencias():
                        if asist.ruta.codigoRuta == codigo:
                            print(asist)
                            encontradas = True
                    if not encontradas:
                        mensaje("advertencia", "No hay asistencias registradas para esta ruta")
                    pausar()
                else:
                    mensaje("error", "Ruta no encontrada")
                    pausar()
        elif opcion == 5:
            fecha = validaCadena(10, 10, "Ingrese fecha (DD/MM/AAAA): ")
            print(f"\n{Back.BLUE}{Fore.WHITE}{'═'*50}{Style.RESET_ALL}")
            print(f"{Fore.BLUE}{Style.BRIGHT}   ASISTENCIAS DEL {fecha}{Style.RESET_ALL}")
            print(f"{Back.BLUE}{Fore.WHITE}{'═'*50}{Style.RESET_ALL}")
            encontradas = False
            for asist in empresa.getAsistencias():
                if fecha in asist.fecha:
                    print(asist)
                    encontradas = True
            if not encontradas:
                mensaje("advertencia", f"No hay asistencias registradas para {fecha}")
            pausar()
        elif opcion == 6:
            break

# FUNCIONES DE REPORTES
def generarReportes(empresa):
    while True:
        limpiarPantalla()
        opcion = menuReportes()
        
        if opcion == 1:
            # Rutas más utilizadas
            print(f"\n{Back.CYAN}{Fore.BLACK}{'═'*50}{Style.RESET_ALL}")
            print(f"{Fore.CYAN}{Style.BRIGHT}   RUTAS MÁS UTILIZADAS{Style.RESET_ALL}")
            print(f"{Back.CYAN}{Fore.BLACK}{'═'*50}{Style.RESET_ALL}")
            rutasOrdenadas = sorted(empresa.getRutas(), key=lambda r: r.getNumeroEstudiantes(), reverse=True)
            if rutasOrdenadas:
                for i, ruta in enumerate(rutasOrdenadas[:5], 1):
                    print(f"{Fore.YELLOW}{i}.{Style.RESET_ALL} {Fore.WHITE}{ruta.codigoRuta} - {ruta.nombre}:{Style.RESET_ALL} {Fore.GREEN}{ruta.getNumeroEstudiantes()} estudiantes{Style.RESET_ALL}")
            else:
                mensaje("advertencia", "No hay rutas registradas")
            pausar()
        
        elif opcion == 2:
            # Estudiantes con mayor asistencia
            print(f"\n{Back.GREEN}{Fore.BLACK}{'═'*50}{Style.RESET_ALL}")
            print(f"{Fore.GREEN}{Style.BRIGHT}   ESTUDIANTES CON MAYOR ASISTENCIA{Style.RESET_ALL}")
            print(f"{Back.GREEN}{Fore.BLACK}{'═'*50}{Style.RESET_ALL}")
            conteoAsistencias = {}
            for asist in empresa.getAsistencias():
                if asist.estado == "Presente":
                    codigo = asist.estudiante.codigoEstudiante
                    conteoAsistencias[codigo] = conteoAsistencias.get(codigo, 0) + 1
            
            if conteoAsistencias:
                estudiantesOrdenados = sorted(conteoAsistencias.items(), key=lambda x: x[1], reverse=True)
                for i, (codigo, asistencias) in enumerate(estudiantesOrdenados[:10], 1):
                    estudiante = empresa.buscarEstudiante(codigo)
                    print(f"{Fore.YELLOW}{i}.{Style.RESET_ALL} {Fore.WHITE}{codigo} - {estudiante.getNombre()} {estudiante.getApellidoPaterno()}:{Style.RESET_ALL} {Fore.GREEN}{asistencias} asistencias{Style.RESET_ALL}")
            else:
                mensaje("advertencia", "No hay asistencias registradas")
            pausar()
        
        elif opcion == 3:
            # Vehículos más usados
            print(f"\n{Back.MAGENTA}{Fore.WHITE}{'═'*50}{Style.RESET_ALL}")
            print(f"{Fore.MAGENTA}{Style.BRIGHT}   VEHÍCULOS MÁS USADOS{Style.RESET_ALL}")
            print(f"{Back.MAGENTA}{Fore.WHITE}{'═'*50}{Style.RESET_ALL}")
            vehiculosConRuta = [v for v in empresa.getVehiculos() if v.rutaAsignada]
            if vehiculosConRuta:
                for i, vehiculo in enumerate(vehiculosConRuta, 1):
                    estudiantes = vehiculo.rutaAsignada.getNumeroEstudiantes() if vehiculo.rutaAsignada else 0
                    print(f"{Fore.YELLOW}{i}.{Style.RESET_ALL} {Fore.WHITE}{vehiculo.codigoVehiculo} - {vehiculo.marca} ({vehiculo.placa}):{Style.RESET_ALL} {Fore.CYAN}Ruta {vehiculo.rutaAsignada.codigoRuta}{Style.RESET_ALL} - {Fore.GREEN}{estudiantes} estudiantes{Style.RESET_ALL}")
            else:
                mensaje("advertencia", "No hay vehículos asignados a rutas")
            pausar()
        
        elif opcion == 4:
            # Conductores con más recorridos
            print(f"\n{Back.YELLOW}{Fore.BLACK}{'═'*50}{Style.RESET_ALL}")
            print(f"{Fore.YELLOW}{Style.BRIGHT}   CONDUCTORES CON MÁS RECORRIDOS{Style.RESET_ALL}")
            print(f"{Back.YELLOW}{Fore.BLACK}{'═'*50}{Style.RESET_ALL}")
            conductoresOrdenados = sorted(empresa.getConductores(), key=lambda c: c.recorridos, reverse=True)
            if conductoresOrdenados:
                for i, conductor in enumerate(conductoresOrdenados[:10], 1):
                    print(f"{Fore.YELLOW}{i}.{Style.RESET_ALL} {Fore.WHITE}{conductor.codigoConductor} - {conductor.getNombre()} {conductor.getApellidoPaterno()}:{Style.RESET_ALL} {Fore.GREEN}{conductor.recorridos} recorridos{Style.RESET_ALL}")
            else:
                mensaje("advertencia", "No hay conductores registrados")
            pausar()
        
        elif opcion == 5:
            # Ingresos por ruta
            print(f"\n{Back.GREEN}{Fore.BLACK}{'═'*50}{Style.RESET_ALL}")
            print(f"{Fore.GREEN}{Style.BRIGHT}   INGRESOS POR RUTA{Style.RESET_ALL}")
            print(f"{Back.GREEN}{Fore.BLACK}{'═'*50}{Style.RESET_ALL}")
            if empresa.getRutas():
                totalIngresos = 0
                for ruta in empresa.getRutas():
                    ingreso = ruta.calcularIngresoMensual()
                    totalIngresos += ingreso
                    print(f"{Fore.CYAN}{ruta.codigoRuta} - {ruta.nombre}:{Style.RESET_ALL} {Fore.GREEN}S/. {ingreso:.2f}{Style.RESET_ALL}")
                print(f"\n{Back.GREEN}{Fore.WHITE}{'═'*50}{Style.RESET_ALL}")
                print(f"{Fore.WHITE}{Style.BRIGHT}TOTAL INGRESOS MENSUALES:{Style.RESET_ALL} {Fore.GREEN}{Style.BRIGHT}S/. {totalIngresos:.2f}{Style.RESET_ALL}")
                print(f"{Back.GREEN}{Fore.WHITE}{'═'*50}{Style.RESET_ALL}")
            else:
                mensaje("advertencia", "No hay rutas registradas")
            pausar()
        
        elif opcion == 6:
            # Estudiantes con pagos pendientes
            print(f"\n{Back.RED}{Fore.WHITE}{'═'*50}{Style.RESET_ALL}")
            print(f"{Fore.RED}{Style.BRIGHT}   ESTUDIANTES CON PAGOS PENDIENTES{Style.RESET_ALL}")
            print(f"{Back.RED}{Fore.WHITE}{'═'*50}{Style.RESET_ALL}")
            pendientes = [e for e in empresa.getEstudiantes() if not e.estadoPago]
            if pendientes:
                for estudiante in pendientes:
                    rutaInfo = f"Ruta {estudiante.rutaAsignada.codigoRuta}" if estudiante.rutaAsignada else "Sin ruta"
                    print(f"{Fore.RED}-{Style.RESET_ALL} {Fore.WHITE}{estudiante.codigoEstudiante} - {estudiante.getNombre()} {estudiante.getApellidoPaterno()}{Style.RESET_ALL} {Fore.CYAN}({rutaInfo}){Style.RESET_ALL}")
                print(f"\n{Fore.YELLOW}Total:{Style.RESET_ALL} {Fore.RED}{Style.BRIGHT}{len(pendientes)} estudiantes con pago pendiente{Style.RESET_ALL}")
            else:
                mensaje("exito", "¡Todos los estudiantes están al día con sus pagos!")
            pausar()
        
        elif opcion == 7:
            # Conductores con licencia próxima a vencer
            print(f"\n{Back.YELLOW}{Fore.BLACK}{'═'*50}{Style.RESET_ALL}")
            print(f"{Fore.YELLOW}{Style.BRIGHT}   CONDUCTORES - VIGENCIA DE LICENCIA{Style.RESET_ALL}")
            print(f"{Back.YELLOW}{Fore.BLACK}{'═'*50}{Style.RESET_ALL}")
            if empresa.getConductores():
                for conductor in empresa.getConductores():
                    print(f"{Fore.CYAN}{conductor.codigoConductor} - {conductor.getNombre()} {conductor.getApellidoPaterno()}:{Style.RESET_ALL} {Fore.YELLOW}Vence {conductor.vigenciaLicencia}{Style.RESET_ALL}")
            else:
                mensaje("advertencia", "No hay conductores registrados")
            pausar()
        
        elif opcion == 8:
            # Reporte general del sistema
            print(empresa)
            print(f"\n{Back.CYAN}{Fore.BLACK}{'═'*50}{Style.RESET_ALL}")
            print(f"{Fore.CYAN}{Style.BRIGHT}   DETALLES DEL SISTEMA{Style.RESET_ALL}")
            print(f"{Back.CYAN}{Fore.BLACK}{'═'*50}{Style.RESET_ALL}")
            print(f"{Fore.GREEN}-{Style.RESET_ALL} {Fore.WHITE}Estudiantes al día:{Style.RESET_ALL} {Fore.GREEN}{len([e for e in empresa.getEstudiantes() if e.estadoPago])}{Style.RESET_ALL}")
            print(f"{Fore.RED}-{Style.RESET_ALL} {Fore.WHITE}Estudiantes con pago pendiente:{Style.RESET_ALL} {Fore.RED}{len([e for e in empresa.getEstudiantes() if not e.estadoPago])}{Style.RESET_ALL}")
            print(f"{Fore.CYAN}-{Style.RESET_ALL} {Fore.WHITE}Conductores con vehículo:{Style.RESET_ALL} {Fore.CYAN}{len([c for c in empresa.getConductores() if c.vehiculoAsignado])}{Style.RESET_ALL}")
            print(f"{Fore.MAGENTA}-{Style.RESET_ALL} {Fore.WHITE}Vehículos en servicio:{Style.RESET_ALL} {Fore.MAGENTA}{len([v for v in empresa.getVehiculos() if v.rutaAsignada])}{Style.RESET_ALL}")
            print(f"{Fore.YELLOW}-{Style.RESET_ALL} {Fore.WHITE}Estudiantes con ruta asignada:{Style.RESET_ALL} {Fore.YELLOW}{len([e for e in empresa.getEstudiantes() if e.rutaAsignada])}{Style.RESET_ALL}")
            
            if empresa.getRutas():
                totalCapacidad = sum(v.capacidad for v in empresa.getVehiculos())
                totalEstudiantes = len(empresa.getEstudiantes())
                print(f"\n{Fore.BLUE}-{Style.RESET_ALL} {Fore.WHITE}Capacidad total de vehículos:{Style.RESET_ALL} {Fore.BLUE}{totalCapacidad}{Style.RESET_ALL}")
                print(f"{Fore.BLUE}-{Style.RESET_ALL} {Fore.WHITE}Ocupación:{Style.RESET_ALL} {Fore.GREEN}{totalEstudiantes}{Style.RESET_ALL}/{Fore.BLUE}{totalCapacidad}{Style.RESET_ALL}")
            pausar()
        
        elif opcion == 9:
            break

# FUNCIONES DE GRÁFICOS
def gestionarGraficos(empresa):
    """Gestiona los gráficos estadísticos del sistema"""
    datos = datosTransporte(empresa)
    datos.generarGrafico()

# FUNCIÓN PRINCIPAL
def main():
    mostrarBanner()
    nombre_empresa = validaCadena(3, 100, "\nIngrese el nombre de la empresa: ")
    empresa = Empresa(nombre_empresa)
    mensaje("exito", f"Empresa '{nombre_empresa}' creada correctamente")
    
    # Cargar datos precargados
    print(f"\n{Back.CYAN}{Fore.BLACK}{'═'*50}{Style.RESET_ALL}")
    print(f"{Fore.CYAN}{Style.BRIGHT}   CARGANDO DATOS INICIALES{Style.RESET_ALL}")
    print(f"{Back.CYAN}{Fore.BLACK}{'═'*50}{Style.RESET_ALL}\n")
    
    # Agregar estudiantes
    empresa.getEstudiantes().extend([
        estudiante1, estudiante2, estudiante3, estudiante4, estudiante5,
        estudiante6, estudiante7, estudiante8, estudiante9, estudiante10
    ])
    print(f"{Fore.GREEN}[OK]{Style.RESET_ALL} {Fore.WHITE}10 estudiantes cargados{Style.RESET_ALL}")
    
    # Agregar conductores
    empresa.getConductores().extend([
        conductor1, conductor2, conductor3, conductor4, conductor5
    ])
    print(f"{Fore.GREEN}[OK]{Style.RESET_ALL} {Fore.WHITE}5 conductores cargados{Style.RESET_ALL}")
    
    # Agregar vehículos
    empresa.getVehiculos().extend([
        vehiculo1, vehiculo2, vehiculo3, vehiculo4, vehiculo5
    ])
    print(f"{Fore.GREEN}[OK]{Style.RESET_ALL} {Fore.WHITE}5 vehículos cargados{Style.RESET_ALL}")
    
    # Agregar rutas
    empresa.getRutas().extend([
        ruta1, ruta2, ruta3, ruta4, ruta5
    ])
    print(f"{Fore.GREEN}[OK]{Style.RESET_ALL} {Fore.WHITE}5 rutas cargadas{Style.RESET_ALL}")
    
    # Agregar asistencias
    empresa.getAsistencias().extend([
        asistencia1, asistencia2, asistencia3, asistencia4, asistencia5,
        asistencia6, asistencia7, asistencia8, asistencia9, asistencia10,
        asistencia11, asistencia12, asistencia13, asistencia14, asistencia15,
        asistencia16, asistencia17, asistencia18, asistencia19, asistencia20,
        asistencia21
    ])
    print(f"{Fore.GREEN}[OK]{Style.RESET_ALL} {Fore.WHITE}21 asistencias cargadas{Style.RESET_ALL}")
    
    print(f"\n{Back.GREEN}{Fore.WHITE}{'═'*50}{Style.RESET_ALL}")
    mensaje("exito", "¡Sistema listo con datos de prueba!")
    print(f"{Back.GREEN}{Fore.WHITE}{'═'*50}{Style.RESET_ALL}")
    input(f"\n{Fore.YELLOW}Presione ENTER para continuar...{Style.RESET_ALL}")
    
    while True:
        limpiarPantalla()
        mostrarBanner()
        opcion = menuPrincipal()
        
        if opcion == 1:
            gestionarEstudiantes(empresa)
        elif opcion == 2:
            gestionarConductores(empresa)
        elif opcion == 3:
            gestionarVehiculos(empresa)
        elif opcion == 4:
            gestionarRutas(empresa)
        elif opcion == 5:
            gestionarAsignaciones(empresa)
        elif opcion == 6:
            gestionarAsistencia(empresa)
        elif opcion == 7:
            generarReportes(empresa)
        elif opcion == 8:
            gestionarGraficos(empresa)
        elif opcion == 9:
            print(empresa)
            pausar()
        elif opcion == 10:
            print(f"\n{Back.CYAN}{Fore.BLACK}{'═'*50}{Style.RESET_ALL}")
            print(f"{Fore.CYAN}{Style.BRIGHT}   Gracias por usar el sistema{Style.RESET_ALL}")
            print(f"{Back.CYAN}{Fore.BLACK}{'═'*50}{Style.RESET_ALL}\n")
            break

if __name__ == "__main__":
    main()