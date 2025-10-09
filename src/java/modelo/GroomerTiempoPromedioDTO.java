package modelo;

public class GroomerTiempoPromedioDTO {
    private String nombreGroomer;
    private double tiempoPromedioMinutos;
    
    public GroomerTiempoPromedioDTO() {}

    public GroomerTiempoPromedioDTO(String nombreGroomer, double tiempoPromedioMinutos) {
        this.nombreGroomer = nombreGroomer;
        this.tiempoPromedioMinutos = tiempoPromedioMinutos;
    }

    // Getters y Setters
    public String getNombreGroomer() { return nombreGroomer; }
    public void setNombreGroomer(String nombreGroomer) { this.nombreGroomer = nombreGroomer; }
    
    public double getTiempoPromedioMinutos() { return tiempoPromedioMinutos; }
    public void setTiempoPromedioMinutos(double tiempoPromedioMinutos) { this.tiempoPromedioMinutos = tiempoPromedioMinutos; }
    
    // Método auxiliar para formatear el tiempo
    public String getTiempoFormateado() {
        int horas = (int) (tiempoPromedioMinutos / 60);
        int minutos = (int) (tiempoPromedioMinutos % 60);
        
        if (horas > 0) {
            return String.format("%d h %d min", horas, minutos);
        } else {
            return String.format("%d min", minutos);
        }
    }
}