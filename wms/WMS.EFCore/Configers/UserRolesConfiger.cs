using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using WMS.Domain.Entity.User;

namespace WMS.EFCore.Configers
{
    /// <summary>
    /// 用户角色
    /// </summary>
    internal class UserRolesConfiger : IEntityTypeConfiguration<UserRoles>
    {
        public void Configure(EntityTypeBuilder<UserRoles> builder)
        {
            builder.ToTable(nameof(UserRoles));
            builder.HasKey(e => e.UserRolesID);
            builder.Property(e => e.UserID).IsRequired().HasColumnType("int");
            builder.Property(e => e.RolesID).IsRequired().HasColumnType("int");
        }
    }
}
