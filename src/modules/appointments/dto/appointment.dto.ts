import {
  IsNotEmpty,
  IsString,
  IsOptional,
  IsNumber,
  IsEnum,
  IsDateString,
  Min,
} from 'class-validator';
import { AppointmentStatus } from '../entities/appointment.entity';

export class CreateAppointmentDto {
  @IsDateString()
  @IsNotEmpty()
  appointmentDateTime: string;

  @IsNumber()
  @IsNotEmpty()
  customerId: number;

  @IsNumber()
  @IsNotEmpty()
  serviceId: number;

  @IsNumber()
  @IsNotEmpty()
  staffId: number;

  @IsString()
  @IsOptional()
  notes?: string;

  @IsNumber({ maxDecimalPlaces: 2 })
  @Min(0)
  @IsOptional()
  totalPrice?: number;

  @IsEnum(AppointmentStatus)
  @IsOptional()
  status?: AppointmentStatus;
}

export class UpdateAppointmentDto {
  @IsDateString()
  @IsOptional()
  appointmentDateTime?: string;

  @IsNumber()
  @IsOptional()
  customerId?: number;

  @IsNumber()
  @IsOptional()
  serviceId?: number;

  @IsNumber()
  @IsOptional()
  staffId?: number;

  @IsString()
  @IsOptional()
  notes?: string;

  @IsNumber({ maxDecimalPlaces: 2 })
  @Min(0)
  @IsOptional()
  totalPrice?: number;

  @IsEnum(AppointmentStatus)
  @IsOptional()
  status?: AppointmentStatus;
}

export class AppointmentFilterDto {
  @IsOptional()
  @IsNumber()
  customerId?: number;

  @IsOptional()
  @IsNumber()
  serviceId?: number;

  @IsOptional()
  @IsNumber()
  staffId?: number;

  @IsOptional()
  @IsEnum(AppointmentStatus)
  status?: AppointmentStatus;

  @IsOptional()
  @IsDateString()
  startDate?: string;

  @IsOptional()
  @IsDateString()
  endDate?: string;
}