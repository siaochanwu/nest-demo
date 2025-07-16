export type User = {
  id: string;
  name: string;
  email: string;
  password: string;
  mobile: string;
  username: string;
  roles: string[];
};

export interface UserFilter {
  id?: string;
  name?: string;
  email?: string;
  mobile?: string;
  username?: string;
}
