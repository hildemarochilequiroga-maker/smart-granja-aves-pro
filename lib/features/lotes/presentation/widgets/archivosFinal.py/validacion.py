def mensaje(tipo, texto):
    if tipo == "exito":
        print(f"✓ Éxito: {texto}")
    elif tipo == "advertencia":
        print(f"⚠ Advertencia: {texto}")
    elif tipo == "error":
        print(f"✗ Error: {texto}")
    else:
        print(texto)

def validaEntero(minimo, maximo, mensaje):
    while True:
        try:
            valor = int(input(mensaje))
            if minimo <= valor <= maximo:
                return valor
            else:
                print(f"Por favor, ingresa un número entre {minimo} y {maximo}.")
        except ValueError:
            print("Entrada inválida. Por favor, ingresa un número entero.")

def validaCadena(minimo, maximo, mensaje):
    while True:
        valor = input(mensaje)
        if minimo <= len(valor) <= maximo:
            return valor
        else:
            print(f"Por favor, ingresa una cadena de texto entre {minimo} y {maximo} caracteres.")

def validaFlotante(minimo, maximo, mensaje):
    while True:
        try:
            valor = float(input(mensaje))
            if minimo <= valor <= maximo:
                return valor
            else:
                print(f"Por favor, ingresa un número entre {minimo} y {maximo}.")
        except ValueError:
            print("Entrada inválida. Por favor, ingresa un número válido.")

def validaDNI(mensaje):
    while True:
        dni = input(mensaje)
        if len(dni) == 8 and dni.isdigit():
            return dni
        else:
            print("DNI inválido. Debe contener exactamente 8 dígitos numéricos.")

def validaTelefono(mensaje):
    while True:
        telefono = input(mensaje)
        if len(telefono) == 9 and telefono.isdigit():
            return telefono
        else:
            print("Teléfono inválido. Debe contener exactamente 9 dígitos numéricos.")

def validaEdad(mensaje):
    while True:
        try:
            edad = int(input(mensaje))
            if 1 <= edad <= 100:
                return edad
            else:
                print("Por favor, ingresa una edad válida entre 1 y 120 años.")
        except ValueError:
            print("Entrada inválida. Por favor, ingresa un número entero.")

def validaOpcion(opciones, mensaje):
    while True:
        print(mensaje)
        for i, opcion in enumerate(opciones, 1):
            print(f"{i}. {opcion}")
        try:
            seleccion = int(input("Selecciona una opción: "))
            if 1 <= seleccion <= len(opciones):
                return seleccion
            else:
                print(f"Por favor, selecciona un número entre 1 y {len(opciones)}.")
        except ValueError:
            print("Entrada inválida. Por favor, ingresa un número entero.")

def validaSiNo(mensaje):
    while True:
        respuesta = input(mensaje + " (S/N): ").upper()
        if respuesta == "S" or respuesta == "SI":
            return True
        elif respuesta == "N" or respuesta == "NO":
            return False
        else:
            print("Por favor, ingresa S (Sí) o N (No).")

def validaPlaca(mensaje):
    while True:
        placa = input(mensaje).upper()
        if len(placa) >= 6 and len(placa) <= 7:
            return placa
        else:
            print("Placa inválida. Debe tener entre 6 y 7 caracteres.")
