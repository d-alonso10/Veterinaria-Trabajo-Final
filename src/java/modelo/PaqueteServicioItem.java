package modelo;

public class PaqueteServicioItem {
    private int idPaquete;
    private int idServicio;
    private int cantidad;

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
}