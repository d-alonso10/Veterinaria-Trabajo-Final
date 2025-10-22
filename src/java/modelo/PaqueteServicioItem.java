package modelo;

public class PaqueteServicioItem {
    private int idPaquete;
    private int idServicio;
    private int cantidad;
    
    // Campos adicionales para consultas con JOIN
    private String nombreServicio;
    private double precioUnitario;
    private int duracionMinutos;

    public PaqueteServicioItem() {}

    public PaqueteServicioItem(int idPaquete, int idServicio, int cantidad) {
        this.idPaquete = idPaquete;
        this.idServicio = idServicio;
        this.cantidad = cantidad;
    }

    public int getIdPaquete() { return idPaquete; }
    public void setIdPaquete(int idPaquete) { this.idPaquete = idPaquete; }
    public int getIdServicio() { return idServicio; }
    public void setIdServicio(int idServicio) { this.idServicio = idServicio; }
    public int getCantidad() { return cantidad; }
    public void setCantidad(int cantidad) { this.cantidad = cantidad; }
    
    // Getters y setters para campos adicionales
    public String getNombreServicio() { return nombreServicio; }
    public void setNombreServicio(String nombreServicio) { this.nombreServicio = nombreServicio; }
    public double getPrecioUnitario() { return precioUnitario; }
    public void setPrecioUnitario(double precioUnitario) { this.precioUnitario = precioUnitario; }
    public int getDuracionMinutos() { return duracionMinutos; }
    public void setDuracionMinutos(int duracionMinutos) { this.duracionMinutos = duracionMinutos; }
}