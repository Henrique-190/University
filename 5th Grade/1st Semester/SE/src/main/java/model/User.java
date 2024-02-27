package model;

public abstract class User{
	private String address;
	private final String email;
	private final String name;
	private String password;
	private final String username;
	private final String phone_number;

	public User(String address, String email, String name, String password, String username, String phone_number) {
		this.address = address;
		this.email = email;
		this.name = name;
		this.password = password;
		this.username = username;
		this.phone_number = phone_number;
	}

	public String getAddress() {
		return address;
	}

	public void setAddress(String address) {
		this.address = address;
	}

	public String getEmail() {
		return email;
	}

	public String getName() {
		return name;
	}

	public String getPassword() {
		return password;
	}

	public void setPassword(String password) {
		this.password = password;
	}

	public String getUsername() {
		return username;
	}

	public String getPhone_number() {
		return phone_number;
	}
}