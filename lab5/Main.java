public class Main {

    public static double evalPoly(double[] coefs, int degree, double x) {
        double result = coefs[degree];

        for (int i = degree - 1; i >= 0; i--)
            result = result * x + coefs[i];

        return result;
    }

    public static void main(String[] args) {
        // Przykładowe współczynniki dla wielomianu 3x^3 + 2x^2 - 5x + 2
        double[] coefs = {3, 2, -5, 2};
        int degree = coefs.length - 1;
        double x = 1.5;

        double result = evalPoly(coefs, degree, x);
        System.out.println("Wynik: " + result);
    }
}
