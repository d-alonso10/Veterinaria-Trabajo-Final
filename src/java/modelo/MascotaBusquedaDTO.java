package modelo;

public class MascotaBusquedaDTO {
    private int idMascota;
    private String nombre;
    private String especie;
    private String raza;
    private String microchip;
    private String clienteNombre;
    private String clienteApellido;

    public MascotaBusquedaDTO() {}

    public MascotaBusquedaDTO(int idMascota, String nombre, String especie, String raza, String microchip, String clienteNombre, String clienteApellido) {
        this.idMascota = idMascota;
        this.nombre = nombre;
        this.especie = especie;
        this.raza = raza;
        this.microchip = microchip;
        this.clienteNombre = clienteNombre;
        this.clienteApellido = clienteApellido;
    }

    // Getters y Setters
    public int getIdMascota() { return idMascota; }
    public void setIdMascota(int idMascota) { this.idMascota = idMascota; }
    public String getNombre() { return nombre; }
    public void setNombre(String nombre) { this.nombre = nombre; }
    public String getEspecie() { return especie; }
    public void setEspecie(String especie) { this.especie = especie; }
    public String getRaza() { return raza; }
    public void setRaza(String raza) { this.raza = raza; }
    public String getMicrochip() { return microchip; }
    public void setMicrochip(String microchip) { this.microchip = microchip; }
    public String getClienteNombre() { return clienteNombre; }
    public void setClienteNombre(String clienteNombre) { this.clienteNombre = clienteNombre; }
    public String getClienteApellido() { return clienteApellido; }
    public void setClienteApellido(String clienteApellido) { this.clienteApellido = clienteApellido; }
    
    // Método auxiliar para nombre completo del cliente
    public String getClienteNombreCompleto() {
        return clienteNombre + " " + clienteApellido;
    }
}