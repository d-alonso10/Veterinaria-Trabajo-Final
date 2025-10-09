package modelo;

public class TiempoPromedioGroomerDTO {
    private String nombreGroomer;
    private int totalAtenciones;
    private double tiempoPromedioMinutos;
    private int tiempoMinimo;
    private int tiempoMaximo;

    // Getters y Setters
    public String getNombreGroomer() { return nombreGroomer; }
    public void setNombreGroomer(String nombreGroomer) { this.nombreGroomer = nombreGroomer; }
    public int getTotalAtenciones() { return totalAtenciones; }
    public void setTotalAtenciones(int totalAtenciones) { this.totalAtenciones = totalAtenciones; }
    public double getTiempoPromedioMinutos() { return tiempoPromedioMinutos; }
    public void setTiempoPromedioMinutos(double tiempoPromedioMinutos) { this.tiempoPromedioMinutos = tiempoPromedioMinutos; }
    public int getTiempoMinimo() { return tiempoMinimo; }
    public void setTiempoMinimo(int tiempoMinimo) { this.tiempoMinimo = tiempoMinimo; }
    public int getTiempoMaximo() { return tiempoMaximo; }
    public void setTiempoMaximo(int tiempoMaximo) { this.tiempoMaximo = tiempoMaximo; }
    
    // Método auxiliar para clasificar eficiencia
    public String getNivelEficiencia() {
        if (tiempoPromedioMinutos <= 30) return "Muy Alto";
        else if (tiempoPromedioMinutos <= 45) return "Alto";
        else if (tiempoPromedioMinutos <= 60) return "Medio";
        else if (tiempoPromedioMinutos <= 90) return "Bajo";
        else return "Muy Bajo";
    }
}