package modelo;

public class EstimacionTiempoDTO {
    private int idServicio;
    private int idGroomer;
    private String servicio;
    private String groomer;
    private int tiempoEstimadoMin;
    private int duracionBase;
    private String nivelEficiencia; // si ya existe, ok

    // getters y setters nuevos
    public int getIdServicio() { return idServicio; }
    public void setIdServicio(int idServicio) { this.idServicio = idServicio; }
    public int getIdGroomer() { return idGroomer; }
    public void setIdGroomer(int idGroomer) { this.idGroomer = idGroomer; }

    // getters y setters existentes
    public String getServicio() { return servicio; }
    public void setServicio(String servicio) { this.servicio = servicio; }
    public String getGroomer() { return groomer; }
    public void setGroomer(String groomer) { this.groomer = groomer; }
    public int getTiempoEstimadoMin() { return tiempoEstimadoMin; }
    public void setTiempoEstimadoMin(int tiempoEstimadoMin) { this.tiempoEstimadoMin = tiempoEstimadoMin; }
    public int getDuracionBase() { return duracionBase; }
    public void setDuracionBase(int duracionBase) { this.duracionBase = duracionBase; }
    public String getNivelEficiencia() { return nivelEficiencia; }
    public void setNivelEficiencia(String nivelEficiencia) { this.nivelEficiencia = nivelEficiencia; }
}
