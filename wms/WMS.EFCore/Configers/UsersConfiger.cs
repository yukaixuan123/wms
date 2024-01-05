using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using WMS.Domain.Entity.Sys;
using WMS.Domain.Entity.User;

namespace WMS.EFCore.Configers
{
    /// <summary>
    /// 用户表
    /// </summary>
    internal class UsersConfiger : IEntityTypeConfiguration<Users>
    {
        public void Configure(EntityTypeBuilder<Users> builder)
        {
            builder.ToTable(nameof(Users));
            builder.HasKey(e => e.U_id);
            builder.Property(e => e.U_name).IsRequired().HasMaxLength(20);
            builder.Property(e => e.U_True_name).IsRequired().HasMaxLength(20);
            builder.Property(e => e.U_password).IsRequired().HasMaxLength(500);
            builder.Property(e => e.U_State);
            builder.Property(e => e.is_del).HasColumnType("char(1)").IsRequired(false);
        }
    }
}
