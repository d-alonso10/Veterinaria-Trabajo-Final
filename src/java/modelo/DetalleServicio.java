package modelo;

public class DetalleServicio {
    private int idDetalle;
    private int idAtencion;
    private int idServicio;
    private int cantidad;
    private double precioUnitario;
    private int descuentoId;
    private double subtotal;
    private String observaciones;

    public DetalleServicio() {}

    public DetalleServicio(int idDetalle, int idAtencion, int idServicio, int cantidad, double precioUnitario, int descuentoId, double subtotal, String observaciones) {
        this.idDetalle = idDetalle;
        this.idAtencion = idAtencion;
        this.idServicio = idServicio;
        this.cantidad = cantidad;
        this.precioUnitario = precioUnitario;
        this.descuentoId = descuentoId;
        this.subtotal = subtotal;
        this.observaciones = observaciones;
    }

    public int getIdDetalle() { return idDetalle; }
    public void setIdDetalle(int idDetalle) { this.idDetalle = idDetalle; }
    public int getIdAtencion() { return idAtencion; }
    public void setIdAtencion(int idAtencion) { this.idAtencion = idAtencion; }
    public int getIdServicio() { return idServicio; }
    public void setIdServicio(int idServicio) { this.idServicio = idServicio; }
    public int getCantidad() { return cantidad; }
    public void setCantidad(int cantidad) { this.cantidad = cantidad; }
    public double getPrecioUnitario() { return precioUnitario; }
    public void setPrecioUnitario(double precioUnitario) { this.precioUnitario = precioUnitario; }
    public int getDescuentoId() { return descuentoId; }
    public void setDescuentoId(int descuentoId) { this.descuentoId = descuentoId; }
    public double getSubtotal() { return subtotal; }
    public void setSubtotal(double subtotal) { this.subtotal = subtotal; }
    public String getObservaciones() { return observaciones; }
    public void setObservaciones(String observaciones) { this.observaciones = observaciones; }
}