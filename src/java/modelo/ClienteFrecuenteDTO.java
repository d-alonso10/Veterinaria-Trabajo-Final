package modelo;

public class ClienteFrecuenteDTO {
    private int idCliente;
    private String nombre;
    private String apellido;
    private String email;
    private String telefono;
    private int totalAtenciones;
    private int totalMascotas;
    private double totalGastado;

    // Getters y Setters
    public int getIdCliente() { return idCliente; }
    public void setIdCliente(int idCliente) { this.idCliente = idCliente; }
    public String getNombre() { return nombre; }
    public void setNombre(String nombre) { this.nombre = nombre; }
    public String getApellido() { return apellido; }
    public void setApellido(String apellido) { this.apellido = apellido; }
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
    public String getTelefono() { return telefono; }
    public void setTelefono(String telefono) { this.telefono = telefono; }
    public int getTotalAtenciones() { return totalAtenciones; }
    public void setTotalAtenciones(int totalAtenciones) { this.totalAtenciones = totalAtenciones; }
    public int getTotalMascotas() { return totalMascotas; }
    public void setTotalMascotas(int totalMascotas) { this.totalMascotas = totalMascotas; }
    public double getTotalGastado() { return totalGastado; }
    public void setTotalGastado(double totalGastado) { this.totalGastado = totalGastado; }
    
    // Método auxiliar
    public String getNombreCompleto() {
        return nombre + " " + apellido;
    }
}