import createCache from "@emotion/cache";

export const createEmotionCache = () => {
  // TODO remove prepend: true once JSS is out
  return createCache({ key: "css", prepend: true });
};
