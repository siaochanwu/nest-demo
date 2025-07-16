export { User } from './entities/user.entity';

export interface UserFilter {
  id?: number;
  name?: string;
  email?: string;
  mobile?: string;
  username?: string;
}
