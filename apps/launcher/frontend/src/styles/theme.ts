import { red } from "@mui/material/colors";
import { createTheme } from "@mui/material/styles";

export const theme = createTheme({
  palette: {
    mode: "dark",
    primary: {
      main: "#556cd6"
    },
    secondary: {
      main: "#19857b"
    },
    error: {
      main: red.A400
    }
  },
  components: {
    MuiLink: {
      defaultProps: {
        underline: "hover"
      }
    }
  },
  typography: {
    fontFamily: "Poppins, Roboto, sans-serif"
  }
});
