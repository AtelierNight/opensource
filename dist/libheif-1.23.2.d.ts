export type HeifImage = {
  free(): void;
  get_width(): number;
  get_height(): number;
  is_primary(): boolean;
  display(image: ImageData, callback: (image: ImageData | null) => void): void;
};

export type HeifDecoder = {
  decoder: unknown;
  decode(bytes: Uint8Array): HeifImage[];
};

export type LibheifModule = {
  HeifDecoder: new () => HeifDecoder;
  de265_get_version(): string;
  heif_context_free(context: unknown): void;
  heif_get_version(): string;
};

declare const createLibheif: (options: { wasmBinary: ArrayBuffer }) => Promise<LibheifModule>;
export default createLibheif;
