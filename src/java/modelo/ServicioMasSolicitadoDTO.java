package modelo;

public class ServicioMasSolicitadoDTO {
    private String nombre;
    private String categoria;
    private int vecesSolicitado;
    private int cantidadTotal;
    private double ingresosGenerados;

    // Getters y Setters
    public String getNombre() { return nombre; }
    public void setNombre(String nombre) { this.nombre = nombre; }
    public String getCategoria() { return categoria; }
    public void setCategoria(String categoria) { this.categoria = categoria; }
    public int getVecesSolicitado() { return vecesSolicitado; }
    public void setVecesSolicitado(int vecesSolicitado) { this.vecesSolicitado = vecesSolicitado; }
    public int getCantidadTotal() { return cantidadTotal; }
    public void setCantidadTotal(int cantidadTotal) { this.cantidadTotal = cantidadTotal; }
    public double getIngresosGenerados() { return ingresosGenerados; }
    public void setIngresosGenerados(double ingresosGenerados) { this.ingresosGenerados = ingresosGenerados; }
}