export type User = {
  id: number;
  name: string;
  email: string;
  password: string;
  mobile: string;
};

export interface UserFilter {
  id?: number;
  name?: string;
  email?: string;
  mobile?: string;
}
