import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository, Between } from 'typeorm';
import { Appointment } from './entities/appointment.entity';
import {
  CreateAppointmentDto,
  UpdateAppointmentDto,
  AppointmentFilterDto,
} from './dto/appointment.dto';

@Injectable()
export class AppointmentsService {
  constructor(
    @InjectRepository(Appointment)
    private readonly appointmentRepository: Repository<Appointment>,
  ) {}

  async findAll(filter?: AppointmentFilterDto): Promise<Appointment[]> {
    const where: any = {};

    if (filter) {
      if (filter.customerId) where.customerId = filter.customerId;
      if (filter.serviceId) where.serviceId = filter.serviceId;
      if (filter.staffId) where.staffId = filter.staffId;
      if (filter.status) where.status = filter.status;

      if (filter.startDate && filter.endDate) {
        where.appointmentDateTime = Between(
          new Date(filter.startDate),
          new Date(filter.endDate),
        );
      } else if (filter.startDate) {
        where.appointmentDateTime = Between(
          new Date(filter.startDate),
          new Date(),
        );
      }
    }

    return this.appointmentRepository.find({
      where,
      relations: ['customer', 'service', 'staff'],
      order: { appointmentDateTime: 'ASC' },
    });
  }

  async findOne(id: number): Promise<Appointment | null> {
    return this.appointmentRepository.findOne({
      where: { id },
      relations: ['customer', 'service', 'staff'],
    });
  }

  async findByCustomer(customerId: number): Promise<Appointment[]> {
    return this.appointmentRepository.find({
      where: { customerId },
      relations: ['customer', 'service', 'staff'],
      order: { appointmentDateTime: 'DESC' },
    });
  }

  async findByStaff(staffId: number): Promise<Appointment[]> {
    return this.appointmentRepository.find({
      where: { staffId },
      relations: ['customer', 'service', 'staff'],
      order: { appointmentDateTime: 'ASC' },
    });
  }

  async create(
    createAppointmentDto: CreateAppointmentDto,
  ): Promise<Appointment> {
    const appointment = this.appointmentRepository.create(createAppointmentDto);
    return this.appointmentRepository.save(appointment);
  }

  async update(
    id: number,
    updateAppointmentDto: UpdateAppointmentDto,
  ): Promise<Appointment | null> {
    await this.appointmentRepository.update(id, updateAppointmentDto);
    return this.findOne(id);
  }

  async remove(id: number): Promise<boolean> {
    const result = await this.appointmentRepository.delete(id);
    return result.affected ? result.affected > 0 : false;
  }
}
